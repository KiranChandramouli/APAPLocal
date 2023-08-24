$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.CHQ.DRW.CLRH.DATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.CHQ.DRW.CLRH.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.NOF. is the BUILD ROUTINE TO SUBTRACT DATE-1 IN THE
*               ENQ REDO.APAP.INWARD.CHQ.REV.CLR.RPT
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ------------------------    ----------------              ----------------
* 30 DEC 2010    PRASHANTH RAI                 ODR-2010-03-0163              Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY

    Y.DATE =O.DATA
    Y.REGION = R.COMPANY(EB.COM.LOCAL.COUNTRY):'00'
    CALL CDT(Y.REGION,Y.DATE,'-1W')

    O.DATA =Y.DATE
RETURN
END
