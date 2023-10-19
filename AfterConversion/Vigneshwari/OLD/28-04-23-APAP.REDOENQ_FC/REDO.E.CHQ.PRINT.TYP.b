$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CHQ.PRINT.TYP

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.CHQ.PRINT.TYP
*---------------------------------------------------------

* Description :
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.V
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.HOLD.CONTROL


    FN.HOLD.CONTROL ='F.HOLD.CONTROL'
    F.HOLD.CONTROL =''
    CALL OPF(FN.HOLD.CONTROL,F.HOLD.CONTROL)



    CALL F.READ(FN.HOLD.CONTROL,O.DATA,R.HOLD.CONTROL,F.HOLD.CONTROL,Y.ERR)
    Y.REPORT = R.HOLD.CONTROL<HCF.REPORT.NAME>

    IF Y.REPORT EQ 'LETTER.1' THEN
        O.DATA = 'CHEQUE'
    END


    IF Y.REPORT EQ 'LETTER' THEN
        O.DATA = 'CONSTANCIA ENTREGA'
    END

RETURN

END
