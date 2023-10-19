$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.ADJUST
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.ADJUST
*--------------------------------------------------------------------------------------------------------
*Description       : This is a conversion  routine for the enquiry for displaying multi values sets
*Linked With       : Enquiry REDO.LOAN.PAYMNET
*In  Parameter     : N/A
*Out Parameter     : Y.OUT.ARRAY
*Files  Used       : AA.ARRANGEMENT
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                        Reference                   Description
*     ------               -----                      -------------                -------------
* 25 Nov 2010            Arulprakasam P               ODR-2010-03-0142- 166              Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.DATA = ID
    Y.CURR = FIELD(Y.DATA,'*',13,1)
    Y.PREV = FIELD(Y.DATA,'*',14,1)

    Y.CUR.VALUE  = Y.CURR<1,VC>
    Y.PREV.VALUE = Y.PREV<1,VC>
    IF ISDIGIT(Y.CUR.VALUE) AND ISDIGIT(Y.PREV.VALUE) THEN
        IF LEN(Y.CUR.VALUE) NE 8 AND LEN(Y.PREV.VALUE) NE 8 THEN
            ADJ.VA = Y.CUR.VALUE - Y.PREV.VALUE
        END ELSE
            NOF.DAYS = "C"
            CALL CDD ("",Y.PREV.VALUE,Y.CUR.VALUE,NOF.DAYS)
            ADJ.VA = NOF.DAYS
        END
    END
    O.DATA = ADJ.VA
RETURN
