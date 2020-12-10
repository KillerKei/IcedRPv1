$(function () {
  let height = 25.5;
  window.addEventListener("message", function (event) {
    if (event.data.type == "updateStatusHud") {
      $("#varSetHealth")
        .find(".progressBar")
        .attr("style", "width: " + event.data.varSetHealth + "%;");
      $("#varSetArmor")
        .find(".progressBar")
        .attr("style", "width: " + event.data.varSetArmor + "%;");

      widthHeightSplit(
        event.data.varSetHunger,
        $("#varSetHunger").find(".progressBar")
      );
      widthHeightSplit(
        event.data.varSetThirst,
        $("#varSetThirst").find(".progressBar")
      );
      widthHeightSplit(
        event.data.varSetOxy,
        $("#varSetOxy").find(".progressBar")
      );
      widthHeightSplit(
        event.data.varSetStress,
        $("#varSetStress").find(".progressBar")
      );

      let voice = event.data.varSetVoice;
      $(".dev").addClass("hidden");
      $(".devDebug").addClass("hidden");
      if (voice == 1) {
        $(".voice1").fadeIn();
        $(".voice2").fadeOut();
        $(".voice3").fadeOut();
        $("#box").fadeIn();
      }
      if (voice == 2) {
        $(".voice1").fadeIn();
        $(".voice2").fadeIn();
        $(".voice3").fadeOut();
        $("#box").fadeIn();
      }
      if (voice == 3) {
        $(".voice1").fadeIn();
        $(".voice2").fadeIn();
        $(".voice3").fadeIn();
        $("#box").fadeIn();
      }
      if (event.data.varDev == true) {
        $(".dev").removeClass("hidden");
      }
      if (event.data.varDevDebug == true) {
        $(".devDebug").removeClass("hidden");
      }
      if (event.data.hasParachute == true) {
        $("#parachute").removeClass("hidden");
      } else {
        $("#parachute").addClass("hidden");
      }

      changeColor($(".progress-health"), event.data.varSetHealth, false)
      changeColor($(".progress-armor"), event.data.varSetArmor, false)
      changeColor($(".progress-burger"), event.data.varSetHunger, false)
      changeColor($(".progress-water"), event.data.varSetThirst, false)
      changeColor($(".progress-oxygen"), event.data.varSetOxy, false)
      changeColor($(".progress-stress"), event.data.varSetStress, true)
      Progress(event.data.varSetHealth,'.progress-health')
      Progress(event.data.varSetHunger,'.progress-burger')
      Progress(event.data.varSetThirst,'.progress-water')
      Progress(event.data.varSetArmor,'.progress-armor')         
      Progress(event.data.varSetOxy,'.progress-oxygen')   
      Progress(event.data.varSetStress,'.progress-stress')

      if (event.data.varSetArmor <= 0) {
        $("#varSetArmor").find(".barIcon").removeClass("danger");
      }
      
      if (event.data.colorblind === true) {
        $(".progressBar").addClass("colorBlind");
      } else {
        $(".progressBar").removeClass("colorBlind");
      }
    } else if (event.data.type == "talkingStatus") {
      if (event.data.is_talking) {
        $("#voiceon").fadeIn();
      } else {
        $("#voiceon").fadeOut();
      }
    } else if (event.data.type == "transmittingStatus") {
      if (event.data.is_transmitting) {
        $("#radioon").fadeIn();
      } else {
        $("#radioon").fadeOut();
      }
    }
  });

  function widthHeightSplit(value, ele) {
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.attr(
      "style",
      "height: " + eleHeight + "px; top: " + leftOverHeight + "px;"
    );
  }

  function changeColor(ele, value, flip) {
    let add = false;
    if (flip) {
      if (value > 85) {
        add = true;
      }
    } else {
      if (value < 25) {
        add = true;
      }
    }

    if (add) {
      // ele.find(".barIcon").addClass("danger")
      ele.find(".progressBar").addClass("dangerGrad");
    } else {
      // ele.find(".barIcon").removeClass("danger")
      ele.find(".progressBar").removeClass("dangerGrad");
    }
  }
});

function Progress(percent, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find("span");

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}