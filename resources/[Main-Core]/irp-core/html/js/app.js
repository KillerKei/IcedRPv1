(() => {

	irpCore = {};
	irpCore.HUDElements = [];

	irpCore.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	irpCore.insertHUDElement = function (name, index, priority, html, data) {
		irpCore.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		irpCore.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	irpCore.updateHUDElement = function (name, data) {

		for (let i = 0; i < irpCore.HUDElements.length; i++) {
			if (irpCore.HUDElements[i].name == name) {
				irpCore.HUDElements[i].data = data;
			}
		}

		irpCore.refreshHUD();
	};

	irpCore.deleteHUDElement = function (name) {
		for (let i = 0; i < irpCore.HUDElements.length; i++) {
			if (irpCore.HUDElements[i].name == name) {
				irpCore.HUDElements.splice(i, 1);
			}
		}

		irpCore.refreshHUD();
	};

	irpCore.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < irpCore.HUDElements.length; i++) {
			let html = Mustache.render(irpCore.HUDElements[i].html, irpCore.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	irpCore.inventoryNotification = function (add, item, count) {
		let notif = '';

		if (add) {
			notif += '+';
		} else {
			notif += '-';
		}

		notif += count + ' ' + item.label;

		let elem = $('<div>' + notif + '</div>');

		$('#inventory_notifications').append(elem);

		$(elem).delay(3000).fadeOut(1000, function () {
			elem.remove();
		});
	};

	window.onData = (data) => {
		switch (data.action) {
			case 'setHUDDisplay': {
				irpCore.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				irpCore.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				irpCore.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				irpCore.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				irpCore.inventoryNotification(data.add, data.item, data.count);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();