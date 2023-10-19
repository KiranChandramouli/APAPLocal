* @ValidationCode : MjotODM5NjU0OTQyOkNwMTI1MjoxNjgxODEzOTkxMzc3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 16:03:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VBA.ACCT.RBHP.GEN
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Marimuthu S (TAM)
* Program Name  : REDO.VBA.ACCT.RBHP.GEN
*-------------------------------------------------------------------------
* Description: This routine is a After auth routine for the Version ACCOUNT,RBHP
*-------------------------------------------------------------------------
* Linked with   : VERSION>ACCOUNT,RBHP
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 13-02-13
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SPF
    $INSERT I_System

    $INSERT I_F.REDO.ACCT.EXCE.RBHP

    IF R.SPF.SYSTEM<SPF.OP.MODE> NE 'B' THEN
        GOSUB OPEN.PROCESS
        GOSUB PROCESS
    END

RETURN

*------------
OPEN.PROCESS:
*------------

    FN.REDO.ACCT.EXCE.RBHP='F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP=''
    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

RETURN

*-------
PROCESS:
*-------

    CURRNT.COMP = System.getVariable("CURRENT.USER.BRANCH")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        CURRNT.COMP = ""
    END ;*AUTO R22 CODE CONVERSION - END

    IF CURRNT.COMP EQ "CURRENT.USER.BRANCH" THEN
        LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
            E = ''
        END
        RETURN
    END

    Y.ID = APPLICATION:'-':CURRNT.COMP:'-':ID.NEW

    ERR.EXCE = ''
    R.REDO.ACCT.EXCE.RBHP = ''

    CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,Y.ID,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,ERR.EXCE)
    IF R.REDO.ACCT.EXCE.RBHP THEN
        CALL F.DELETE(FN.REDO.ACCT.EXCE.RBHP,Y.ID)
    END

RETURN

END
