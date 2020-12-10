(function () {

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="dialog {{#isBig}}big{{/isBig}}">' +
			'<div class="head"><span>{{title}}</span></div>' +
				'{{#isDefault}}<input type="text" name="value" id="inputText"/>{{/isDefault}}' +
				'{{#isBig}}<textarea name="value"/>{{/isBig}}' +
				'<button type="button" name="submit">Zapisz</button>' +
				'<button type="button" name="cancel">Zamknij</button>' +
			'</div>' +
		'</div>'
	;

	window.irpCore_MENU       = {};
	irpCore_MENU.ResourceName = 'irp-menu-dialog';
	irpCore_MENU.opened       = {};
	irpCore_MENU.focus        = [];
	irpCore_MENU.pos          = {};

	irpCore_MENU.open = function (namespace, name, data) {

		if (typeof irpCore_MENU.opened[namespace] == 'undefined') {
			irpCore_MENU.opened[namespace] = {};
		}

		if (typeof irpCore_MENU.opened[namespace][name] != 'undefined') {
			irpCore_MENU.close(namespace, name);
		}

		if (typeof irpCore_MENU.pos[namespace] == 'undefined') {
			irpCore_MENU.pos[namespace] = {};
		}

		if (typeof data.type == 'undefined') {
			data.type = 'default';
		}

		if (typeof data.align == 'undefined') {
			data.align = 'top-left';
		}

		data._index = irpCore_MENU.focus.length;
		data._namespace = namespace;
		data._name = name;

		irpCore_MENU.opened[namespace][name] = data;
		irpCore_MENU.pos[namespace][name] = 0;

		irpCore_MENU.focus.push({
			namespace: namespace,
			name: name
		});

		document.onkeyup = function (key) {
			if (key.which == 27) { // Escape key
				$.post('http://' + irpCore_MENU.ResourceName + '/menu_cancel', JSON.stringify(data));
			} else if (key.which == 13) { // Enter key
				$.post('http://' + irpCore_MENU.ResourceName + '/menu_submit', JSON.stringify(data));
			}
		};

		irpCore_MENU.render();

	};

	irpCore_MENU.close = function (namespace, name) {

		delete irpCore_MENU.opened[namespace][name];

		for (let i = 0; i < irpCore_MENU.focus.length; i++) {
			if (irpCore_MENU.focus[i].namespace == namespace && irpCore_MENU.focus[i].name == name) {
				irpCore_MENU.focus.splice(i, 1);
				break;
			}
		}

		irpCore_MENU.render();

	};

	irpCore_MENU.render = function () {

		let menuContainer = $('#menus')[0];

		$(menuContainer).find('button[name="submit"]').unbind('click');
		$(menuContainer).find('button[name="cancel"]').unbind('click');
		$(menuContainer).find('[name="value"]').unbind('input propertychange');

		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in irpCore_MENU.opened) {
			for (let name in irpCore_MENU.opened[namespace]) {

				let menuData = irpCore_MENU.opened[namespace][name];
				let view = JSON.parse(JSON.stringify(menuData));

				switch (menuData.type) {
					case 'default': {
						view.isDefault = true;
						break;
					}

					case 'big': {
						view.isBig = true;
						break;
					}

					default: break;
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];

				$(menu).css('z-index', 1000 + view._index);

				$(menu).find('button[name="submit"]').click(function () {
					irpCore_MENU.submit(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				$(menu).find('button[name="cancel"]').click(function () {
					irpCore_MENU.cancel(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				$(menu).find('[name="value"]').bind('input propertychange', function () {
					this.data.value = $(menu).find('[name="value"]').val();
					irpCore_MENU.change(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				if (typeof menuData.value != 'undefined')
					$(menu).find('[name="value"]').val(menuData.value);

				menuContainer.appendChild(menu);
			}
		}

		$(menuContainer).show();
		$("#inputText").focus();
	};

	irpCore_MENU.submit = function (namespace, name, data) {
		$.post('http://' + irpCore_MENU.ResourceName + '/menu_submit', JSON.stringify(data));
	};

	irpCore_MENU.cancel = function (namespace, name, data) {
		$.post('http://' + irpCore_MENU.ResourceName + '/menu_cancel', JSON.stringify(data));
	};

	irpCore_MENU.change = function (namespace, name, data) {
		$.post('http://' + irpCore_MENU.ResourceName + '/menu_change', JSON.stringify(data));
	};

	irpCore_MENU.getFocused = function () {
		return irpCore_MENU.focus[irpCore_MENU.focus.length - 1];
	};

	window.onData = (data) => {

		switch (data.action) {
			case 'openMenu': {
				irpCore_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu': {
				irpCore_MENU.close(data.namespace, data.name);
				break;
			}
		}

	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();