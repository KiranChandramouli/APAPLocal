$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.LEGAL.PROSPECT(ENQ.DATA)
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAHAMATHULLAH.B
*---------------------------------------------------------
* Description :ASOCIACOPN POPULAR DE AHORROS Y PRESTAMOS
*              requires a report that shows all prospective clients,
*              which are captured through events, e-mail, etc
*----------------------------------------------------------
* Linked With : Enquiry REDO.APAP.NATURAL.AND.LEGAL.PROSP
* In Parameter : ENQ.DATA
* Out Parameter : ENQ.DATA
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*
*-----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    LOCATE "DATE.TIME" IN ENQ.DATA<2,1> SETTING TIPO.POS THEN
        Y.JOIN.DATE = ENQ.DATA<4,TIPO.POS>
        ENQ.DATA<3,TIPO.POS> ="LK"
        ENQ.DATA<4,TIPO.POS> = Y.JOIN.DATE[3,6]:"..."
        ENQ.DATA<2,-1> = "CURR.NO"
        ENQ.DATA<3,-1> = "EQ"
        ENQ.DATA<4,-1> = 1
    END

    LOCATE "L.CU.TIPO.CL" IN ENQ.DATA<2,1> SETTING CL.POS THEN
        Y.TIPO.CL = ENQ.DATA<4,CL.POS>
        ENQ.DATA<4,CL.POS> = "'":Y.TIPO.CL:"'"
    END

RETURN
END
