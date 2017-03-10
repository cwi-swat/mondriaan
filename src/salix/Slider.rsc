module salix::Slider
import salix::HTML;
import Prelude;

data Msg;

Msg(int) partial(Msg(int, int) f, int p) {return Msg(int y){return f(p, y);};}

void _slider(Msg(int) msg, num low, num high, num step) {
    salix::HTML::input(
            salix::HTML::\type("range")
           ,salix::HTML::min("<low>")
           ,salix::HTML::max("<high>")
           ,salix::HTML::step("<step>")
           ,salix::HTML::onChange(msg)
         );
    }
    
   
void tableCell(Msg(int, int) msg, int id, num low, num high, num step, str label) {
     td(label);
     td("<low>");
     td(() {_slider(partial(msg ,id), low, high, step);});
     td("<high>");
     }
   
void tableRow(list[list[tuple[Msg(int, int) msg, int id, str label, num low, num high, num step]]] sliders) {
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
                  tableCell(slid.msg, slid.id, slid.low, slid.high, slid.step, slid.label);
                 });
            });
            });}
           });
   }
   
void slider(list[list[list[tuple[Msg(int, int) msg, int id, str label, num low, num high, num step]]]] sliders) { 
       list[tuple[str, str]] styles=[];     
       styles += <"border-spacing", "5px 5px">;
       styles+= <"border-collapse", "separate">;
       styles+= <"width", "1000px">;
       table(salix::HTML::style(styles), (){
            for (list[list[tuple[Msg(int, int) msg, int id, str label, num low, num high, num step]]] slids<-sliders) {
                tableRow(slids);                      
                }
           });
    }