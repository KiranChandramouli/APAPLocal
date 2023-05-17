SUBROUTINE REDO.E.BLD.ADD.CARD.DETAILS(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : PRABHU N
* Program Name  : REDO.E.BLD.ADD.CARD.DETAILS
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* related to showing last five transactions
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 09-09-2010         ODR-2010-08-0031                Routine for STMT.ENTRY

*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_System
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

RETURN

*---------
OPENFILES:
*---------
*Tables required:ACCT.STMT.PRINT and STMT.PRINTED
*----------------------------------------------------------------------------------

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

RETURN

*-----------------------------------------
PROCESS:
*-----------------------------------------

    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.USR.VAR = ""
    END
    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.ADD.CARD.LIST.CUS"
*Read Converted by TUS-Convert
    READ CARD.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR THEN ;*Tus Start
*CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,CARD.DATA,F.REDO.EB.USER.PRINT.VAR,CARD.DATA.ERR)
* IF CARD.DATA THEN  ;* Tus End
        ENQ.DATA<2,1>='@ID'
        ENQ.DATA<3,1>='EQ'
        ENQ.DATA<4,1>='SYSTEM'
    END ELSE
        ENQ.DATA<2,1>='@ID'
        ENQ.DATA<3,1>='EQ'
        ENQ.DATA<4,1>='FAIL'
    END

RETURN

PGM.END:
END
