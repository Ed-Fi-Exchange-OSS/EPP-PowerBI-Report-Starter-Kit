.then(() => {
    var year = new Date().getFullYear()
    $("#schoolYearSelect option[value='" + year + "']").removeAttr("selected")
    $("#schoolYearSelect option[value='" + (year + 1) + "']").attr("selected", "selected")
  })
