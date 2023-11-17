* @ValidationCode : MjotMzg3MzUxNDg0OkNwMTI1MjoxNjgyMDczMzgyMDUwOklUU1M6LTE6LTE6MTcyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 172
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
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
* 17-APR-2023     Conversion tool    R22 Auto conversion       IF Condition added
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
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
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - start
        Y.USR.VAR = ""
    END					;*R22 Auto conversion - end
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
