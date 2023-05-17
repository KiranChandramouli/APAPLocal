*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.REGN16.FMT.VAL
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 18-06-2015        Ashokkumar                PACS00465380- Initial revision
*-------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE

  FIN.VAL = ''
  YCLAIM.VAL = COMI
  IF YCLAIM.VAL THEN

    CHANGE FM TO "" IN YCLAIM.VAL
    CHANGE VM TO "" IN YCLAIM.VAL
    CHANGE SM TO "" IN YCLAIM.VAL

* PACS00465380 - 2015/JUL/15 - S

    CHANGE CHARX(9) TO " " IN YCLAIM.VAL          ;* Tabulador
    CHANGE CHARX(161) TO "" IN YCLAIM.VAL         ;* Admiracion que abre
    CHANGE CHARX(168) TO "" IN YCLAIM.VAL         ;* Dieresis
    CHANGE CHARX(180) TO "" IN YCLAIM.VAL         ;* Acento grave
    CHANGE CHARX(8230) TO "" IN YCLAIM.VAL        ;* Elipsis baja

    YCLAIM.VAL = UPCASE(YCLAIM.VAL)

    CHANGE CHARX(376) TO "" IN YCLAIM.VAL         ;* Y con dieresis

    CHANGE CHARX(209) TO "" IN YCLAIM.VAL         ;* Enie Mayuscula

    CHANGE CHARX(192) TO "" IN YCLAIM.VAL         ;* A con acento invertido

    CHANGE CHARX(200) TO "" IN YCLAIM.VAL         ;* E con acento inv

    CHANGE CHARX(204) TO "" IN YCLAIM.VAL         ;* I con acento inv

    CHANGE CHARX(210) TO "" IN YCLAIM.VAL         ;* O con acento invertido

    CHANGE CHARX(217) TO "" IN YCLAIM.VAL         ;* U con acento invertido

    CHANGE CHARX(193) TO "" IN YCLAIM.VAL         ;* A acentuada

    CHANGE CHARX(201) TO "" IN YCLAIM.VAL         ;* E acentuada

    CHANGE CHARX(205) TO "" IN YCLAIM.VAL         ;* I acentuada

    CHANGE CHARX(211) TO "" IN YCLAIM.VAL         ;* O acentuada

    CHANGE CHARX(218) TO "" IN YCLAIM.VAL         ;* U acentuada

    YCLAIM.VAL = LOWCASE(YCLAIM.VAL)

    CHANGE CHARX(241) TO "" IN YCLAIM.VAL         ;* Enie Minuscula

    CHANGE CHARX(224) TO "" IN YCLAIM.VAL         ;* a con acento invertido

    CHANGE CHARX(232) TO "" IN YCLAIM.VAL         ;* e con acento invertido

    CHANGE CHARX(236) TO "" IN YCLAIM.VAL         ;* i con acento invertido

    CHANGE CHARX(242) TO "" IN YCLAIM.VAL         ;* o con acento invertido

    CHANGE CHARX(249) TO "" IN YCLAIM.VAL         ;* u con acento invertido

    CHANGE CHARX(225) TO "" IN YCLAIM.VAL         ;* a acentuada

    CHANGE CHARX(233) TO "" IN YCLAIM.VAL         ;* e acentuada

    CHANGE CHARX(237) TO "" IN YCLAIM.VAL         ;* i acentuada

    CHANGE CHARX(243) TO "" IN YCLAIM.VAL         ;* o acentuada

    CHANGE CHARX(250) TO "" IN YCLAIM.VAL         ;* u acentuada

    CHANGE CHARX(255) TO "" IN YCLAIM.VAL         ;* y con dieresis

* PACS00465380 - 2015/JUL/15 - E
    FIN.VAL = YCLAIM.VAL[1,150]
  END
  COMI = FIN.VAL
  RETURN
END
