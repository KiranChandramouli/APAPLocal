* @ValidationCode : MjotMzMwMDM5NTgwOkNwMTI1MjoxNjk4NzUwNjcyNjMwOklUU1MxOi0xOi0xOjA6LTE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : false
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-77</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.TFS
SUBROUTINE CONV.TFS.PARAMETER.G14
*
*--------------------------------------------------------------------------------
* R4/R5 (?!) Changes - Conversion of TFS.PARAMETER from FIN type to INT Type. As a
* result, the ID SYSTEM needs to be changed as Company ID, for each Company
*
*---------------------------------------------------------------------------------
* Modification History:
*
* 04/13/05 - Sathish PS
*            New Development
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion            GLOBUS.BP File Removed
*---------------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion - START
    $INCLUDE I_EQUATE

    $INCLUDE I_F.FILE.CONTROL
    $INCLUDE I_FIN.TO.INT.COMMON ;*R22 Manual Conversion - END

    GOSUB INITIALISE          ;* Initialise variables
    GOSUB PRELIM.CONDS        ;* Preliminary Validations
    IF PROCESS.GOAHEAD THEN
        GOSUB START.TXN.BOUNDARY        ;* Start Txn Boundary
        IF PROCESS.GOAHEAD THEN
            GOSUB CONV.PARAMETER.FILE   ;* Convert FIN to INT
            IF PROCESS.GOAHEAD THEN
                GOSUB END.TXN.BOUNDARY  ;* Commit Txn Boundary
            END ELSE
                GOSUB ABORT.TXN.BOUNDARY          ;* Abort Txn Boundary
            END
        END
    END

    IF FATAL.MSG THEN
        CALL TXT(FATAL.MSG)
        TEXT = FATAL.MSG
        CALL FATAL.ERROR(SYSTEM(40))
    END

RETURN
*---------------------------------------------------------------------------------
INITIALISE:

    PROCESS.GOAHEAD = 1
    FATAL.MSG = ''
*
    FILE.NAME = 'TFS.PARAMETER' ; ID.TYPE = 'SINGLE' ; PRODUCT.ID = 'EB'
    FN.FC = 'F.FILE.CONTROL' ; F.FC = '' ; CALL OPF(FN.FC,F.FC)
*
    COMPANY.LIST = ''         ;* FIN.TO.INT.COMMON Variable

RETURN
*---------------------------------------------------------------------------------
PRELIM.CONDS:

    READ R.FC FROM F.FC,FILE.NAME THEN
        IF R.FC<EB.FILE.CONTROL.CLASS> EQ 'INT' THEN
            TEXT = 'CONVERSION ALREADY RUN'
            CALL REM
            PROCESS.GOAHEAD = 0
        END
    END ELSE
        FATAL.MSG = 'EB-US.REC.MISS.FILE' :FM: FILE.NAME :VM: FN.FC
        PROCESS.GOAHEAD = 0
    END

RETURN
*--------------------------------------------------------------------------------
START.TXN.BOUNDARY:

    CALL EB.TRANS('START',RET.MSG)
    IF RET.MSG THEN
        FATAL.MSG = RET.MSG ; PROCESS.GOAHEAD = 0
    END

RETURN
*---------------------------------------------------------------------------------
END.TXN.BOUNDARY:

    CALL EB.TRANS('END',RET.MSG)
    IF RET.MSG THEN
        FATAL.MSG = RET.MSG ; PROCESS.GOAHEAD = 0
        GOSUB ABORT.TXN.BOUNDARY
    END

RETURN
*---------------------------------------------------------------------------------
ABORT.TXN.BOUNDARY:

    CALL EB.TRANS('ABORT',RET.MSG)
    IF RET.MSG THEN
        FATAL.MSG = RET.MSG
        PROCESS.GOAHEAD = 0
    END ELSE
        TEXT = FATAL.MSG:' - TRANSACTION ABORTED'
        CALL REM
        PROCESS.GOAHEAD = 0
    END

RETURN
*-----------------------------------------------------------------------------
CONV.PARAMETER.FILE:

    R.FC<EB.FILE.CONTROL.CLASS> = 'INT'
    FC.WRITE.ERR = 0
    WRITE R.FC ON F.FILE.CONTROL,FILE.NAME ON ERROR FC.WRITE.ERR = 1
    IF FC.WRITE.ERR THEN
        FATAL.MSG = 'UNABLE TO WRITE & TO & ':FM: FILE.NAME :VM: FN.FC
        PROCESS.GOAHEAD = 0
    END ELSE
        CALL EB.CONV.PARAM.FIN.TO.INT(FILE.NAME,ID.TYPE,PRODUCT.ID)
    END

RETURN
*-------------------------------------------------------------------------------
END


