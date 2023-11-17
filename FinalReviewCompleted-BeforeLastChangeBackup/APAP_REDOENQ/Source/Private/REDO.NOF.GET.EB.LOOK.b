$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.GET.EB.LOOK(Y.DATA)
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.NOF.GET.APPL
*--------------------------------------------------------------------------------
*Description : This routine is used to display the  in selection citeria
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.NOF.GET.APPL
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   02-06-2011       DHAMU S                 CRM                Initial Creation
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.USER


    FN.EB = 'F.EB.LOOKUP'
    F.EB = '' ; Y.DATE = ''

    CALL OPF(FN.EB,F.EB)
    SEL.CMD = " SELECT F.EB.LOOKUP WITH @ID LIKE L.AC.CAN.REASON..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS
        CALL F.READ(FN.EB,Y.ID,R.EB,F.EB,Y.ERR)
        Y.LAN = R.USER<EB.USE.LANGUAGE>
        Y.DES = R.EB<EB.LU.DESCRIPTION>
        Y.DATA<-1> = Y.DES<1,Y.LAN>
    REPEAT
RETURN
END
