* @ValidationCode : MjozMjc4MjU1NzY6Q3AxMjUyOjE2ODExMTE4OTEwNDk6SVRTUzotMTotMTozOTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 399
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AUDIT.LOG.BULK.LOAD

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION

* 04-APR-2023     Conversion tool    R22 Auto conversion    SESSION.NO to AGENT.NUMBER
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_TSA.COMMON ;*R22 Auto conversion
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.AUDIT.LOG.BULD.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.BATCH

    FN.REDO.AUDIT.TRAIL.LOG = 'F.REDO.AUDIT.TRAIL.LOG'
    F.REDO.AUDIT.TRAIL.LOG = ''
    CALL OPF(FN.REDO.AUDIT.TRAIL.LOG,F.REDO.AUDIT.TRAIL.LOG)

    FN.BATCH = 'F.BATCH'
    F.BATCH = ''
    CALL OPF(FN.BATCH,F.BATCH)


    Y.BATCH = BATCH.INFO<1>
    CALL F.READ(FN.BATCH,Y.BATCH,R.BATCH,F.BATCH,BAT.ERR)

    Y.DATAS = R.BATCH<BAT.DATA>
    Y.PATH = Y.DATAS<1,1,1>
    Y.DELIM = Y.DATAS<1,1,2>
    OPEN Y.PATH TO Y.PTR ELSE
        CALL OCOMO("Parameterized path not available")
    END

    Y.SES = AGENT.NUMBER:TODAY:'SEP' ;*R22 Auto conversion

    OPENSEQ Y.PATH,Y.SES TO Y.PTR.S ELSE
        CREATE Y.PTR.S ELSE
            CALL OCOMO("UNABLE TO CREATE FILE ":Y.SES)
        END
    END

RETURN

END
