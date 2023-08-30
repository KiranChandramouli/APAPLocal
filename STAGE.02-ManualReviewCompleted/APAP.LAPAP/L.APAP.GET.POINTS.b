$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.POINTS (ENQ.DATA)
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina para obtener el consolidado de los ceritos de un cliente
* Autor: Anthony Martinez
* Date: 24/04/2019
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.REDO.LY.POINTS.TOT

    GOSUB INIT
    GOSUB GET.NEXT.EXP.DATE
    GOSUB GET.CONSOLIDATED.POINTS

    ENQ.DATA = Y.TOTAL.QTY : '*' : Y.TOTAL.VAL : '*' : Y.NEXT.EXP.DATE
RETURN

INIT:
*****
    Y.CUS.ID = ''
    Y.TOTAL.QTY = 0
    Y.TOTAL.VAL = 0

    SEL.LIST = ""; NO.OF.REC = ""; SEL.ERR = ""; POINT.LIST.POS = ""

    FN.POINT = "F.REDO.LY.POINTS"; FV.POINT = ""; R.POINT = ""; ERR.POINT = ""
    CALL OPF(FN.POINT, FV.POINT)

    FN.POINT.TOT = "F.REDO.LY.POINTS.TOT"; FV.POINT.TOT = ""; R.POINT.TOT = ""; ERR.POINT.TOT = ""
    CALL OPF(FN.POINT.TOT, FV.POINT.TOT)

    LOCATE "CUS.ID" IN D.FIELDS SETTING CUS.ID.POS THEN
        Y.CUS.ID = D.RANGE.AND.VALUE<CUS.ID.POS>
    END

RETURN

GET.CONSOLIDATED.POINTS:
************************

* SEL.CMD = "SELECT F.REDO.LY.POINTS.TOT WITH @ID LIKE ":Y.CUS.ID:"PL...":" AND @ID LIKE ...ALL... AND @ID UNLIKE ":Y.CUS.ID:"PL00002..."
    SEL.CMD = "SELECT F.REDO.LY.POINTS.TOT WITH @ID EQ ":Y.CUS.ID:"C"

    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.OF.RECS, SEL.ERR)

    LOOP

        REMOVE Y.POINT.ID FROM SEL.LIST SETTING POINT.LIST.POS

    WHILE Y.POINT.ID DO

        CALL F.READ(FN.POINT.TOT, Y.POINT.ID, R.POINT.TOT, FV.POINT.TOT, ERR.POINT.TOT)

        Y.TOTAL.QTY = Y.TOTAL.QTY + R.POINT.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
        Y.TOTAL.VAL = Y.TOTAL.VAL + R.POINT.TOT<REDO.PT.T.TOT.AVAIL.VALUE>

    REPEAT

RETURN

GET.NEXT.EXP.DATE:
******************
    CALL F.READ(FN.POINT, Y.CUS.ID, R.POINT, FV.POINT, ERR.POINT)
    Y.NEXT.EXP.DATE = R.POINT<REDO.PT.EXP.DATE, 1, 1>

    Y.CANT.RECS = DCOUNT(R.POINT<REDO.PT.STATUS>, @SM)

    FOR A = 1 TO Y.CANT.RECS STEP 1
        IF  R.POINT<REDO.PT.STATUS, 1, A> EQ 'Liberada' THEN
            Y.NEXT.EXP.DATE = R.POINT<REDO.PT.EXP.DATE, 1, 1>
            RETURN
        END
    NEXT A

RETURN
