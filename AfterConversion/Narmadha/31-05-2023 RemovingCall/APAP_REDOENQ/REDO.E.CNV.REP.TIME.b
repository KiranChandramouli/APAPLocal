$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.REP.TIME
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.GET.TIME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the TIME
*                    from TIME.STAMP and returns it to O.DATA
*Linked With       : Enquiry REDO.APAP.ENQ.S.ACCT.DYN.RPT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*--------------------------------------------------------------------------------------------------------
*Date                   Who                  Reference                        Description
*------                 -----                -------------                    -------------
* 15.11.2010     Sakthi Sellappillai         ODR-2010-08-0173                 Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    GOSUB PROCESS.PARA
    GOSUB GOEND
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------
    Y.TIME.DATE = TIMEDATE()
    O.DATA = Y.TIME.DATE[1,8]
RETURN
*--------------------------------------------------------------------------------------------------------
GOEND:
RETURN
*--------------------------------------------------------------------------------------------------------
END
*-------------------------------------------*END OF SUBROUTINE*------------------------------------------
