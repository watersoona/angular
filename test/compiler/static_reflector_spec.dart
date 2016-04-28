library angular2.test.compiler.static_reflector_spec;

import "package:angular2/testing_internal.dart" show describe, it, expect;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/src/compiler/static_reflector.dart"
    show StaticReflector, StaticReflectorHost;

main() {
  describe("StaticReflector", () {
    it("should get annotations for NgFor", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var NgFor = reflector.getStaticType(
          host.resolveModule("angular2/src/common/directives/ng_for"), "NgFor");
      var annotations = reflector.annotations(NgFor);
      expect(annotations.length).toEqual(1);
      var annotation = annotations[0];
      expect(annotation.selector).toEqual("[ngFor][ngForOf]");
      expect(annotation.inputs)
          .toEqual(["ngForTrackBy", "ngForOf", "ngForTemplate"]);
    });
    it("should get constructor for NgFor", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var NgFor = reflector.getStaticType(
          host.resolveModule("angular2/src/common/directives/ng_for"), "NgFor");
      var ViewContainerRef = reflector.getStaticType(
          host.resolveModule("angular2/src/core/linker/view_container_ref"),
          "ViewContainerRef");
      var TemplateRef = reflector.getStaticType(
          host.resolveModule("angular2/src/core/linker/template_ref"),
          "TemplateRef");
      var IterableDiffers = reflector.getStaticType(
          host.resolveModule(
              "angular2/src/core/change_detection/differs/iterable_differs"),
          "IterableDiffers");
      var ChangeDetectorRef = reflector.getStaticType(
          host.resolveModule(
              "angular2/src/core/change_detection/change_detector_ref"),
          "ChangeDetectorRef");
      var parameters = reflector.parameters(NgFor);
      expect(parameters).toEqual(
          [ViewContainerRef, TemplateRef, IterableDiffers, ChangeDetectorRef]);
    });
    it("should get annotations for HeroDetailComponent", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var HeroDetailComponent = reflector.getStaticType(
          "/src/app/hero-detail.component.ts", "HeroDetailComponent");
      var annotations = reflector.annotations(HeroDetailComponent);
      expect(annotations.length).toEqual(1);
      var annotation = annotations[0];
      expect(annotation.selector).toEqual("my-hero-detail");
    });
    it("should get and empty annotation list for an unknown class", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var UnknownClass =
          reflector.getStaticType("/src/app/app.component.ts", "UnknownClass");
      var annotations = reflector.annotations(UnknownClass);
      expect(annotations).toEqual([]);
    });
    it("should get propMetadata for HeroDetailComponent", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var HeroDetailComponent = reflector.getStaticType(
          "/src/app/hero-detail.component.ts", "HeroDetailComponent");
      var props = reflector.propMetadata(HeroDetailComponent);
      expect(props["hero"]).toBeTruthy();
    });
    it("should get an empty object from propMetadata for an unknown class", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var UnknownClass =
          reflector.getStaticType("/src/app/app.component.ts", "UnknownClass");
      var properties = reflector.propMetadata(UnknownClass);
      expect(properties).toEqual({});
    });
    it("should get empty parameters list for an unknown class ", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var UnknownClass =
          reflector.getStaticType("/src/app/app.component.ts", "UnknownClass");
      var parameters = reflector.parameters(UnknownClass);
      expect(parameters).toEqual([]);
    });
    it("should simplify primitive into itself", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify("", 1)).toBe(1);
      expect(reflector.simplify("", true)).toBe(true);
      expect(reflector.simplify("", "some value")).toBe("some value");
    });
    it("should simplify an array into a copy of the array", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify("", [1, 2, 3])).toEqual([1, 2, 3]);
    });
    it("should simplify an object to a copy of the object", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var expr = {"a": 1, "b": 2, "c": 3};
      expect(reflector.simplify("", expr)).toEqual(expr);
    });
    it("should simplify &&", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "&&",
                "left": true,
                "right": true
              })))
          .toBe(true);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "&&",
                "left": true,
                "right": false
              })))
          .toBe(false);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "&&",
                "left": false,
                "right": true
              })))
          .toBe(false);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "&&",
                "left": false,
                "right": false
              })))
          .toBe(false);
    });
    it("should simplify ||", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "||",
                "left": true,
                "right": true
              })))
          .toBe(true);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "||",
                "left": true,
                "right": false
              })))
          .toBe(true);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "||",
                "left": false,
                "right": true
              })))
          .toBe(true);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "||",
                "left": false,
                "right": false
              })))
          .toBe(false);
    });
    it("should simplify &", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "&",
                "left": 0x22,
                "right": 0x0F
              })))
          .toBe(0x22 & 0x0F);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "&",
                "left": 0x22,
                "right": 0xF0
              })))
          .toBe(0x22 & 0xF0);
    });
    it("should simplify |", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "|",
                "left": 0x22,
                "right": 0x0F
              })))
          .toBe(0x22 | 0x0F);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "|",
                "left": 0x22,
                "right": 0xF0
              })))
          .toBe(0x22 | 0xF0);
    });
    it("should simplify ^", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "|",
                "left": 0x22,
                "right": 0x0F
              })))
          .toBe(0x22 | 0x0F);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "|",
                "left": 0x22,
                "right": 0xF0
              })))
          .toBe(0x22 | 0xF0);
    });
    it("should simplify ==", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "==",
                "left": 0x22,
                "right": 0x22
              })))
          .toBe(0x22 == 0x22);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "==",
                "left": 0x22,
                "right": 0xF0
              })))
          .toBe(0x22 == 0xF0);
    });
    it("should simplify !=", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "!=",
                "left": 0x22,
                "right": 0x22
              })))
          .toBe(0x22 != 0x22);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "!=",
                "left": 0x22,
                "right": 0xF0
              })))
          .toBe(0x22 != 0xF0);
    });
    it("should simplify ===", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "===",
                "left": 0x22,
                "right": 0x22
              })))
          .toBe(identical(0x22, 0x22));
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "===",
                "left": 0x22,
                "right": 0xF0
              })))
          .toBe(identical(0x22, 0xF0));
    });
    it("should simplify !==", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "!==",
                "left": 0x22,
                "right": 0x22
              })))
          .toBe(!identical(0x22, 0x22));
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "!==",
                "left": 0x22,
                "right": 0xF0
              })))
          .toBe(!identical(0x22, 0xF0));
    });
    it("should simplify >", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": ">",
                "left": 1,
                "right": 1
              })))
          .toBe(1 > 1);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": ">",
                "left": 1,
                "right": 0
              })))
          .toBe(1 > 0);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": ">",
                "left": 0,
                "right": 1
              })))
          .toBe(0 > 1);
    });
    it("should simplify >=", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": ">=",
                "left": 1,
                "right": 1
              })))
          .toBe(1 >= 1);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": ">=",
                "left": 1,
                "right": 0
              })))
          .toBe(1 >= 0);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": ">=",
                "left": 0,
                "right": 1
              })))
          .toBe(0 >= 1);
    });
    it("should simplify <=", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "<=",
                "left": 1,
                "right": 1
              })))
          .toBe(1 <= 1);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "<=",
                "left": 1,
                "right": 0
              })))
          .toBe(1 <= 0);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "<=",
                "left": 0,
                "right": 1
              })))
          .toBe(0 <= 1);
    });
    it("should simplify <", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "<",
                "left": 1,
                "right": 1
              })))
          .toBe(1 < 1);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "<",
                "left": 1,
                "right": 0
              })))
          .toBe(1 < 0);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "<",
                "left": 0,
                "right": 1
              })))
          .toBe(0 < 1);
    });
    it("should simplify <<", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "<<",
                "left": 0x55,
                "right": 2
              })))
          .toBe(0x55 << 2);
    });
    it("should simplify >>", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": ">>",
                "left": 0x55,
                "right": 2
              })))
          .toBe(0x55 >> 2);
    });
    it("should simplify +", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "+",
                "left": 0x55,
                "right": 2
              })))
          .toBe(0x55 + 2);
    });
    it("should simplify -", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "-",
                "left": 0x55,
                "right": 2
              })))
          .toBe(0x55 - 2);
    });
    it("should simplify *", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "*",
                "left": 0x55,
                "right": 2
              })))
          .toBe(0x55 * 2);
    });
    it("should simplify /", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "/",
                "left": 0x55,
                "right": 2
              })))
          .toBe(0x55 / 2);
    });
    it("should simplify %", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "binop",
                "operator": "%",
                "left": 0x55,
                "right": 2
              })))
          .toBe(0x55 % 2);
    });
    it("should simplify prefix -", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "", ({"___symbolic": "pre", "operator": "-", "operand": 2})))
          .toBe(-2);
    });
    it("should simplify prefix ~", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "", ({"___symbolic": "pre", "operator": "~", "operand": 2})))
          .toBe(~2);
    });
    it("should simplify prefix !", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "", ({"___symbolic": "pre", "operator": "!", "operand": true})))
          .toBe(!true);
      expect(reflector.simplify(
              "", ({"___symbolic": "pre", "operator": "!", "operand": false})))
          .toBe(!false);
    });
    it("should simplify an array index", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "",
              ({
                "___symbolic": "index",
                "expression": [1, 2, 3],
                "index": 2
              })))
          .toBe(3);
    });
    it("should simplify an object index", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      var expr = {
        "___symbolic": "select",
        "expression": {"a": 1, "b": 2, "c": 3},
        "member": "b"
      };
      expect(reflector.simplify("", expr)).toBe(2);
    });
    it("should simplify a module reference", () {
      var host = new MockReflectorHost();
      var reflector = new StaticReflector(host);
      expect(reflector.simplify(
              "/src/cases",
              ({
                "___symbolic": "reference",
                "module": "./extern",
                "name": "s"
              })))
          .toEqual("s");
    });
  });
}

class MockReflectorHost implements StaticReflectorHost {
  String resolveModule(String moduleName, [String containingFile]) {
    List<String> splitPath(String path) {
      return path.split(new RegExp(r'\/|\\'));
    }
    String resolvePath(List<String> pathParts) {
      var result = [];
      ListWrapper.forEachWithIndex(pathParts, (part, index) {
        switch (part) {
          case "":
          case ".":
            if (index > 0) return;
            break;
          case "..":
            if (index > 0 && result.length != 0) result.removeLast();
            return;
        }
        result.add(part);
      });
      return result.join("/");
    }
    String pathTo(String from, String to) {
      var result = to;
      if (to.startsWith(".")) {
        var fromParts = splitPath(from);
        fromParts.removeLast();
        var toParts = splitPath(to);
        result = resolvePath((new List.from(fromParts)..addAll(toParts)));
      }
      return result;
    }
    if (identical(moduleName.indexOf("."), 0)) {
      return pathTo(containingFile, moduleName) + ".d.ts";
    }
    return "/tmp/" + moduleName + ".d.ts";
  }

  dynamic getMetadataFor(String moduleId) {
    return {
      "/tmp/angular2/src/common/directives/ng_for.d.ts": {
        "___symbolic": "module",
        "metadata": {
          "NgFor": {
            "___symbolic": "class",
            "decorators": [
              {
                "___symbolic": "call",
                "expression": {
                  "___symbolic": "reference",
                  "name": "Directive",
                  "module": "../../core/metadata"
                },
                "arguments": [
                  {
                    "selector": "[ngFor][ngForOf]",
                    "inputs": ["ngForTrackBy", "ngForOf", "ngForTemplate"]
                  }
                ]
              }
            ],
            "members": {
              "___ctor__": [
                {
                  "___symbolic": "constructor",
                  "parameters": [
                    {
                      "___symbolic": "reference",
                      "module": "../../core/linker/view_container_ref",
                      "name": "ViewContainerRef"
                    },
                    {
                      "___symbolic": "reference",
                      "module": "../../core/linker/template_ref",
                      "name": "TemplateRef"
                    },
                    {
                      "___symbolic": "reference",
                      "module":
                          "../../core/change_detection/differs/iterable_differs",
                      "name": "IterableDiffers"
                    },
                    {
                      "___symbolic": "reference",
                      "module":
                          "../../core/change_detection/change_detector_ref",
                      "name": "ChangeDetectorRef"
                    }
                  ]
                }
              ]
            }
          }
        }
      },
      "/tmp/angular2/src/core/linker/view_container_ref.d.ts": {
        "metadata": {
          "ViewContainerRef": {"___symbolic": "class"}
        }
      },
      "/tmp/angular2/src/core/linker/template_ref.d.ts": {
        "module": "./template_ref",
        "metadata": {
          "TemplateRef": {"___symbolic": "class"}
        }
      },
      "/tmp/angular2/src/core/change_detection/differs/iterable_differs.d.ts": {
        "metadata": {
          "IterableDiffers": {"___symbolic": "class"}
        }
      },
      "/tmp/angular2/src/core/change_detection/change_detector_ref.d.ts": {
        "metadata": {
          "ChangeDetectorRef": {"___symbolic": "class"}
        }
      },
      "/src/app/hero-detail.component.ts": {
        "___symbolic": "module",
        "metadata": {
          "HeroDetailComponent": {
            "___symbolic": "class",
            "decorators": [
              {
                "___symbolic": "call",
                "expression": {
                  "___symbolic": "reference",
                  "name": "Component",
                  "module": "angular2/src/core/metadata"
                },
                "arguments": [
                  {
                    "selector": "my-hero-detail",
                    "template":
                        "\n  <div *ngIf=\"hero\">\n    <h2>{{hero.name}} details!</h2>\n    <div><label>id: </label>{{hero.id}}</div>\n    <div>\n      <label>name: </label>\n      <input [(ngModel)]=\"hero.name\" placeholder=\"name\"/>\n    </div>\n  </div>\n"
                  }
                ]
              }
            ],
            "members": {
              "hero": [
                {
                  "___symbolic": "property",
                  "decorators": [
                    {
                      "___symbolic": "call",
                      "expression": {
                        "___symbolic": "reference",
                        "name": "Input",
                        "module": "angular2/src/core/metadata"
                      }
                    }
                  ]
                }
              ]
            }
          }
        }
      },
      "/src/extern.d.ts": {
        "___symbolic": "module",
        "metadata": {"s": "s"}
      }
    }[moduleId];
  }
}
