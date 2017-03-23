module salix::demo::basic::Plot
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::Slider;


alias Model = list[tuple[num x, num f]];

Model startModel = [<0, 1>, <0, 1>];

data Msg
   = moveX(int id, real x)
   | frek(int id,  real f)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case moveX(int id, real x): m[id].x = x;
       case frek(int id, real f):m[id].f = f;
       }
     return m;
}

Model init() = startModel;

//Figure nGon(Model m, int n, int r, num angle) {
//       num shift = 1.0;
//       list[str] pth = [p_.M(-1, 0)];
//       pth += [p_.L(-cos(phi), sin(phi))|num phi<-[2*PI()/n, 4*PI()/n..2*PI()]];
//       pth += [p_.Z()];
//       return box(lineColor="red", fig=
//           path(pth, scaleX = r, scaleY = r, transform=t_.t(shift, shift)+t_.r(angle, 0, 0)
//           , fillColor="none", lineColor="black", lineWidth=6, width = 2*r, height= 2*r)
//       );
//       }

Figure nGon(Model m) {
       return circle(lineColor="red", lineWidth=4, fig=
            ngon(n=6,   grow=1.0, angle=PI(), lineColor="black", lineWidth=8
            ,fig=ngon(n=6, r=40, angle=PI(), lineColor="green", lineWidth=8)));
       }
       
//Figure nGon(Model m) {
//       return ellipse(lineColor="red", grow=sqrt(2), lineWidth=4,  fig=
//             hcat(borderWidth=2,   hgap=0, borderStyle="groove"
//               , figs=[circle(n=3, r=80,  angle=PI(), lineColor="black", lineWidth=6
//                           ,fig=ngon(n=3, r=40, angle=PI(), lineColor="green", lineWidth=8))
//                      ,htmlText( "\<ol\>\<li\>aap\<li\>noot\</ol\>", size=<100, 100>, lineWidth=1, lineColor="black")]
//             ));
//       }


Figure testFigure(Model m) {
     int n  = 20;
     return vcat(vgap=10, width = round(100*2*PI()), figs=[
       box(lineWidth=2, lineColor="black",  fig=overlay(size=<round(100*2*PI()), 210>, figs=[
       path([p_.M(0, sin(m[0].x))]+[p_.L(m[0].f*2*PI()*i/n, sin(2*PI()*(i/n)+m[0].x))|num i<-[1, 2..n+1]]
       ,scaleX=100, scaleY=-100, at=<0, 105>, fillColor="none", lineColor="red", midMarker=circle(r=3, fillColor="black"))
       ,path([p_.M(0, cos(m[1].x))]+[p_.L(m[1].f*2*PI()*i/n, cos(2*PI()*(i/n)+m[1].x))|num i<-[1,2..n+1]]
       ,scaleX=100, scaleY=-100, at=<0, 105>, fillColor="none", lineColor="blue", midMarker=box(size=<6, 6>, lineColor="black"))
       ]))
       , hcat(height=30,  /*width = round(100*2*PI()),*/ align = topLeft, hgap=0, figs=[
              box(fig=htmlText("sin: x=<m[0].x>", fontColor="red"), lineColor="black"), box(fig=htmlText("cos: x=<m[1].x>", fontColor="blue"), lineColor="black")])
       ]);
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        // fig(testFigure(m), width = 800, height = 350); 
        // fig(nGon(m, 4, 50, 0), width = 800, height = 350); 
        fig(nGon(m)); 
        slider([[
                  [<moveX, 0, "sin:", 0, 3.14, 0.1, 0> ]
                 ,[<moveX, 1, "cos:", 0, 3.14, 0.1, 0> ]
                 ]]);   
        });
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://mondriaan/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }