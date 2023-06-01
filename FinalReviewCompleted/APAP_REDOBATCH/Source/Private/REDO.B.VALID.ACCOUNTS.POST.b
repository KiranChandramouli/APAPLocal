* @ValidationCode : MjotMTc2MTE5MTM4MDpDcDEyNTI6MTY4NDg1NDQwMTkyNzpJVFNTOi0xOi0xOjQ3NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 476
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.VALID.ACCOUNTS.POST
******************************************************************************
*-------------------------------------------------------------------------
* Company Name  :  ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  :  NATCHIMUTHU
* Program Name  :  REDO.B.VALID.ACCOUNTS.POST
* ODR           :  ODR-2010-09-0171
*-------------------------------------------------------------------------
* DESCRIPTION:
* This routine clears the DATA value in BATCH record and Concatenate all the files generated by
* agents into a single file and moves the file to remote server specified in REDO.APAP.H.PARAMETER
*----------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------------------------------------
*   DATE         WHO                   ODR                      DESCRIPTION
*  08-10-10      NATCHIMUTHU           ODR-2010-09-0171         Initial Creation
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - ! TO *
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.ACCT.STATUS.CODE
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_REDO.B.VALID.ACCOUNTS.COMMON

    $INSERT I_F.REDO.INTERFACE.ACT
    $INSERT I_F.REDO.INTERFACE.ACT.DETAILS
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.INTERFACE.PARAM

*  DEBUG
    GOSUB INIT
    GOSUB PROCESS
    GOSUB FINALLOG
RETURN

INIT:
*****

    FN.REDO.APAP.H.PARAMETER = 'F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER = ''
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

    FN.ACCOUNT =  'F.ACCOUNT'
    F.ACCOUNT  =  ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.ACCT.STATUS.CODE  =   'F.REDO.ACCT.STATUS.CODE'
    F.REDO.ACCT.STATUS.CODE   =   ''
    CALL OPF(FN.REDO.ACCT.STATUS.CODE,F.REDO.ACCT.STATUS.CODE)

RETURN

PROCESS:
********


*  CALL F.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER,PARAM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,PARAM.ERR) ; * Tus End
    IF PARAM.ERR EQ '' THEN
        CCY.FILE.NAME = R.REDO.APAP.H.PARAMETER<PARAM.APERTA.FILE.NAME>
        CCY.OUT.PATH = R.REDO.APAP.H.PARAMETER<PARAM.APERTA.PATH>
    END

    SHELL.CMD ='SH -c '
    EXEC.COM="cat "
    OLD.OUT.FILES = TODAY:"1":'*'

    FINAL.CCY.FILE.NAME=TODAY:CCY.FILE.NAME

    EXE.CAT = "cat ":CCY.OUT.PATH:"/":OLD.OUT.FILES:" >> ":CCY.OUT.PATH:"/":FINAL.CCY.FILE.NAME

    EXE.RM="rm ":CCY.OUT.PATH:"/":OLD.OUT.FILES
    DAEMON.REM.CMD = SHELL.CMD:EXE.RM

    DAEMON.CMD = SHELL.CMD:EXE.CAT

    EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
    EXECUTE DAEMON.REM.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE

RETURN

FINALLOG:
**********

    INT.CODE = 'APA004'
    CALL REDO.INTERFACE.ACT.POST(INT.CODE)
RETURN
END

*-----------------------------------------------------------------------------------------------------------------
* PROGRAM END
*---------------------------------------------------------------------------------------------------------------------------------
