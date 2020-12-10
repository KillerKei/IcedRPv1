(function(){

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">' +
			'<div class="head"><span>{{{title}}}</span></div>' +
				'<div class="menu-items">' + 
					'{{#elements}}' +
						'<div class="menu-item {{#selected}}selected{{/selected}}">' +
							'{{{label}}}{{#isSlider}} : &lt;{{{sliderLabel}}}&gt;{{/isSlider}}' +
						'</div>' +
					'{{/elements}}' +
				'</div>'+
			'</div>' +
		'</div>'
	;

	window.irpCore_MENU       = {};
	irpCore_MENU.ResourceName = 'irp-menu-default';
	irpCore_MENU.opened       = {};
	irpCore_MENU.focus        = [];
	irpCore_MENU.pos          = {};

	irpCore_MENU.open = function(namespace, name, data) {

		if (typeof irpCore_MENU.opened[namespace] == 'undefined') {
			irpCore_MENU.opened[namespace] = {};
		}

		if (typeof irpCore_MENU.opened[namespace][name] != 'undefined') {
			irpCore_MENU.close(namespace, name);
		}

		if (typeof irpCore_MENU.pos[namespace] == 'undefined') {
			irpCore_MENU.pos[namespace] = {};
		}

		for (let i=0; i<data.elements.length; i++) {
			if (typeof data.elements[i].type == 'undefined') {
				data.elements[i].type = 'default';
			}
		}

		data._index     = irpCore_MENU.focus.length;
		data._namespace = namespace;
		data._name      = name;

		for (let i=0; i<data.elements.length; i++) {
			data.elements[i]._namespace = namespace;
			data.elements[i]._name      = name;
		}

		irpCore_MENU.opened[namespace][name] = data;
		irpCore_MENU.pos   [namespace][name] = 0;

		for (let i=0; i<data.elements.length; i++) {
			if (data.elements[i].selected) {
				irpCore_MENU.pos[namespace][name] = i;
			} else {
				data.elements[i].selected = false;
			}
		}

		irpCore_MENU.focus.push({
			namespace: namespace,
			name     : name
		});
		
		irpCore_MENU.render();
		$('#menu_' + namespace + '_' + name).find('.menu-item.selected')[0].scrollIntoView();
	};

	irpCore_MENU.close = function(namespace, name) {
		
		delete irpCore_MENU.opened[namespace][name];

		for (let i=0; i<irpCore_MENU.focus.length; i++) {
			if (irpCore_MENU.focus[i].namespace == namespace && irpCore_MENU.focus[i].name == name) {
				irpCore_MENU.focus.splice(i, 1);
				break;
			}
		}

		irpCore_MENU.render();

	};

	irpCore_MENU.render = function() {

		let menuContainer       = document.getElementById('menus');
		let focused             = irpCore_MENU.getFocused();
		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in irpCore_MENU.opened) {
			for (let name in irpCore_MENU.opened[namespace]) {

				let menuData = irpCore_MENU.opened[namespace][name];
				let view     = JSON.parse(JSON.stringify(menuData));

				for (let i=0; i<menuData.elements.length; i++) {
					let element = view.elements[i];

					switch (element.type) {
						case 'default' : break;

						case 'slider' : {
							element.isSlider    = true;
							element.sliderLabel = (typeof element.options == 'undefined') ? element.value : element.options[element.value];

							break;
						}

						default : break;
					}

					if (i == irpCore_MENU.pos[namespace][name]) {
						element.selected = true;
					}
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}

		if (typeof focused != 'undefined') {
			$('#menu_' + focused.namespace + '_' + focused.name).show();
		}

		$(menuContainer).show();

	};

	irpCore_MENU.submit = function(namespace, name, data) {
		$.post('http://' + irpCore_MENU.ResourceName + '/menu_submit', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : irpCore_MENU.opened[namespace][name].elements
		}));
	};

	irpCore_MENU.cancel = function(namespace, name) {
		$.post('http://' + irpCore_MENU.ResourceName + '/menu_cancel', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	};

	irpCore_MENU.change = function(namespace, name, data) {
		$.post('http://' + irpCore_MENU.ResourceName + '/menu_change', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : irpCore_MENU.opened[namespace][name].elements
		}));
	};

	irpCore_MENU.getFocused = function() {
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

			case 'controlPressed': {

				switch (data.control) {

					case 'ENTER': {
						let focused = irpCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu    = irpCore_MENU.opened[focused.namespace][focused.name];
							let pos     = irpCore_MENU.pos[focused.namespace][focused.name];
							let elem    = menu.elements[pos];

							if (menu.elements.length > 0) {
								irpCore_MENU.submit(focused.namespace, focused.name, elem);
							}
						}

						break;
					}

					case 'BACKSPACE': {
						let focused = irpCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							irpCore_MENU.cancel(focused.namespace, focused.name);
						}

						break;
					}

					case 'TOP': {

						let focused = irpCore_MENU.getFocused();

						if (typeof focused != 'undefined') {

							let menu = irpCore_MENU.opened[focused.namespace][focused.name];
							let pos  = irpCore_MENU.pos[focused.namespace][focused.name];

							if (pos > 0) {
								irpCore_MENU.pos[focused.namespace][focused.name]--;
							} else {
								irpCore_MENU.pos[focused.namespace][focused.name] = menu.elements.length - 1;
							}

							let elem = menu.elements[irpCore_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == irpCore_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							irpCore_MENU.change(focused.namespace, focused.name, elem);
							irpCore_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;

					}

					case 'DOWN' : {

						let focused = irpCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu   = irpCore_MENU.opened[focused.namespace][focused.name];
							let pos    = irpCore_MENU.pos[focused.namespace][focused.name];
							let length = menu.elements.length;

							if (pos < length - 1) {
								irpCore_MENU.pos[focused.namespace][focused.name]++;
							} else {
								irpCore_MENU.pos[focused.namespace][focused.name] = 0;
							}

							let elem = menu.elements[irpCore_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == irpCore_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							irpCore_MENU.change(focused.namespace, focused.name, elem);
							irpCore_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'LEFT' : {

						let focused = irpCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = irpCore_MENU.opened[focused.namespace][focused.name];
							let pos  = irpCore_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									let min = (typeof elem.min == 'undefined') ? 0 : elem.min;

									if (elem.value > min) {
										elem.value--;
										irpCore_MENU.change(focused.namespace, focused.name, elem);
									}

									irpCore_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'RIGHT' : {

						let focused = irpCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = irpCore_MENU.opened[focused.namespace][focused.name];
							let pos  = irpCore_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
										elem.value++;
										irpCore_MENU.change(focused.namespace, focused.name, elem);
									}

									if (typeof elem.max != 'undefined' && elem.value < elem.max) {
										elem.value++;
										irpCore_MENU.change(focused.namespace, focused.name, elem);
									}

									irpCore_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					default : break;

				}

				break;
			}

		}

	};

	window.onload = function(e){
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();