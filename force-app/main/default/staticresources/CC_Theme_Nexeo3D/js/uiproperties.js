//
// Theme driven uiProperties overrides.  If you want to override elements
// of uiProperties within this file then
// 1) Uncomment the code between //OVERRIDES START HERE and
//                               //OVERRIDES END HERE
// 2) Define the specific property(ies) that you wish to
//    override from the managed package.
//
// Note that you must override according to the full object path
// but you can only override specific values, i.e. you do not need
// to provide the whole object copy.
//
// OVERRIDES START HERE
// CCRZ.uiProperties = $.extend(true,CCRZ.uiProperties,{
//     //Overriden partial objects here
// });
// OVERRIDES END HERE


//https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith
if (!String.prototype.endsWith) {
  String.prototype.endsWith = function(searchString, position) {
      var subjectString = this.toString();
      if (typeof position !== 'number' || !isFinite(position) || Math.floor(position) !== position || position > subjectString.length) {
        position = subjectString.length;
      }
      position -= searchString.length;
      var lastIndex = subjectString.indexOf(searchString, position);
      return lastIndex !== -1 && lastIndex === position;
  };
}
