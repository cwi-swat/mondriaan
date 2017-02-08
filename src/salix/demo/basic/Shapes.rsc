module salix::demo::basic::Shapes
import salix::RenderFigure;
import shapes::Figure;
import salix::HTML;
import salix::App;

Model(Msg , Model) update(Figure f) {
  return 
     Model(Msg msg, Model m) {
       if (msg(str key):= msg)
        switch (key) {
          case "click": 
            if (m[f].fill=="red") {
                m[f].width = 160;
                m[f].fill= "blue";
                }
            else {
                m[f].width = 140;
                m[f].fill = "red";
                }
         }
         return m;
         };
}

App[Model] makeFig() {
    Figure fig = box(width=160, height= 160, fillColor="red", lineWidth = 16, lineColor="brown", event=onclick(msg("click"))
    ,fig=box(width=40, height=40, lineWidth = 4, lineColor="green", fillColor="antiquewhite"), align=bottomLeft);
    fig.before= void() {return h2("Figure using SVG");};
    fig.after = void(){return 
          salix::HTML::div(() {salix::HTML::button(salix::HTML::onClick(msg("click")), "On/Off");})
     ;};
    return figApp(fig, update(fig), width = 400, height = 400);
    }


public App[Model] c = makeFig();


