module salix::Slider
import salix::HTML;
import Prelude;

data Msg;

Msg(real) partial(Msg(int, real) f, int p) {return Msg(real y){return f(p, y);};}

void _slider(Msg(real) msg, num low, num high, num step, num val) {
    salix::HTML::input(
            salix::HTML::\type("range")
           ,salix::HTML::min("<low>")
           ,salix::HTML::max("<high>")
           ,salix::HTML::step("<step>")
           ,salix::HTML::\value("<val>")
           ,salix::HTML::onChange(msg)
         );
    }
    
   
void tableCell(Msg(int, real) msg, int id, num low, num high, num step, num val, str label) {
     td(label);
     td("<low>");
     td(() {_slider(partial(msg ,id), low, high, step, val);});
     td("<high>");
     }
   
void tableRow(list[list[tuple[Msg(int, real) msg, int id, str label, num low, num high, num step, num val]]] sliders) {
      list[tuple[str, str]] styles=[];     
       styles += <"border-spacing", "5px 5px">;
       styles+= <"border-collapse", "separate">;
       styles+= <"border-width", "2">;
       // styles+= <"border-color", "grey">; 
       styles+= <"border-style", "groove
       ">; 
       tr((){ 
         for (slids<-sliders) {
            td(salix::HTML::style(styles), (){
              table(salix::HTML::style(styles), (){
              for (slid <- slids)
                tr((){
                  tableCell(slid.msg, slid.id, slid.low, slid.high, slid.step, slid.val, slid.label);
                 });
            });
            });}
           });
   }
   
void slider(list[list[list[tuple[Msg(int, real) msg, int id, str label, num low, num high, num step, num val]]]] sliders) { 
       list[tuple[str, str]] styles=[];     
       styles += <"border-spacing", "5px 5px">;
       styles+= <"border-collapse", "separate">;
       // styles+= <"width", "1000px">;
       table(salix::HTML::style(styles), (){
            for (list[list[tuple[Msg(int, real) msg, int id, str label, num low, num high, num step, num val]]] slids<-sliders) {
                tableRow(slids);                      
                }
           });
    }