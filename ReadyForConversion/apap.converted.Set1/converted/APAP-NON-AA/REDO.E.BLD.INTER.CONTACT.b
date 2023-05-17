SUBROUTINE REDO.E.BLD.INTER.CONTACT(ENQ.DATA)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : JEEVA T
* Program Name  : REDO.E.BLD.INTER.CONTACT
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have account no as selection field to restrict unauthorised access
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 01-09-10          ODR-2010-08-0031              Routine to validate Account
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CR.CONTACT.LOG

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*---------
OPENFILES:
*---------

    FN.CR.CONTACT.LOG = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT.LOG = ''
    CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)
RETURN
*-------------------
PROCESS:
*----------------------
    LOCATE 'CONTACT.CLIENT' IN ENQ.DATA<2,1> SETTING POS.CON THEN
        VAR.CONT.CLIENT = ENQ.DATA<4,POS.CON>
    END
    SEL.CMD = " SELECT ":FN.CR.CONTACT.LOG:" WITH (CONTACT.TYPE EQ MANUAL OR CONTACT.TYPE EQ AUTOMATICO) AND (CONTACT.CLIENT EQ ":VAR.CONT.CLIENT
    SEL.CMD:=") BY-DSND DATE.TIME"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOF,Y.ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS
        Y.ID.LIST<-1> = Y.ID
        Y.COUNT = DCOUNT(Y.ID.LIST,@FM)
        IF Y.COUNT EQ 20 THEN
            SEL.LIST = ''
        END
    REPEAT
    CHANGE @FM TO ' ' IN Y.ID.LIST

    ENQ.DATA<2,-1> = "@ID"
    ENQ.DATA<3,-1> = "EQ"
    ENQ.DATA<4,-1> = Y.ID.LIST

RETURN
*------------------------------------------------------------------------------------
END
