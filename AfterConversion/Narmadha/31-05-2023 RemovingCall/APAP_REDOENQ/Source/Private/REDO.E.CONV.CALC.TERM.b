$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.CALC.TERM

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep.A
* Program Name : REDO.E.CONV.CALC.TERM
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to THE ENQUIRY REDO.E.OPEN.CAN.INVST.REP
* to populate the label MONEDA
* Get the VALUE.DATE and MATURITY.DATE from AZ.ACCOUNT and call CDD to calulate the difference between two dates
*
*----------------------------------------------------------
* Linked With : Enquiry REDO.E.OPEN.CAN.INVST.REP
* In Parameter : O.DATA
* Out Parameter : O.DATA
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    YTERM.IN = O.DATA
    YOUT.DATE = 'C'
    YVALUE.DT = FIELD(YTERM.IN,'*',1)
    YMATURITY.DT = FIELD(YTERM.IN,'*',2)
    IF LEN(YVALUE.DT) EQ '8' AND LEN(YMATURITY.DT) EQ '8' THEN
        CALL CDD('',YVALUE.DT,YMATURITY.DT,YOUT.DATE)
        O.DATA = YOUT.DATE
    END
RETURN

END
