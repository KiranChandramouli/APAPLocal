* @ValidationCode : MjoxNTI3NTQ4MjY6Q3AxMjUyOjE2ODA3OTAxMDY5NTc6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AUDIT.LOG.BULK.POST
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.AUDIT.LOG.BULD.COMMON


    Y.FILE.NM = 'AUDITLOG.':TODAY:'.csv'

    SHELL.CMD ='SH -c '
    Y.EXE = "cat ":Y.PATH:"/*SEP":" >> ":Y.PATH:"/":Y.FILE.NM

    DAEMON.CMD = SHELL.CMD:Y.EXE
    EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE

    Y.RM.EXE = "rm ":Y.PATH:"/*SEP"
    DAEMON.REM.CMD  = SHELL.CMD:Y.RM.EXE
    EXECUTE DAEMON.REM.CMD RETURNING RET.VAL CAPTURING CAP.REM.VAL

END
