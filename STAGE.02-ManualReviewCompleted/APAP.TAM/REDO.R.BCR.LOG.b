* @ValidationCode : MjoxNjE5NjU5NzMxOkNwMTI1MjoxNjgxMzAwMDY4OTI4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:17:48
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
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.R.BCR.LOG(R.REDO.LOG)
*-----------------------------------------------------------------------------
* Simple Routine to wrap RED.INTERFACE.REC.ACT
*
*-----------------------------------------------------------------------------
* Modification History:
* Revision History:
* -----------------
* Date       Name              Reference                     Version
* --------   ----              ----------                    --------
* 17.04.12   hpasquel           PACS00191153                1.0
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*12/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*12/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    COM/REDO.BCR.LOG/F.REDO.BCR.PROCESS.LOG,FN.REDO.BCR.PROCESS.LOG     ;* This allows to be used in another interfaces
*
    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------------------
    CALL ALLOCATE.UNIQUE.TIME(Y.REDO.LOG.ID)
*

*  WRITE R.REDO.LOG TO F.REDO.BCR.PROCESS.LOG,Y.REDO.LOG.ID ;*Tus Start
    CALL F.WRITE(FN.REDO.BCR.PROCESS.LOG,Y.REDO.LOG.ID,R.REDO.LOG) ;*Tus End
    IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
        CALL JOURNAL.UPDATE('')
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------------------
    IF NOT(FN.REDO.BCR.PROCESS.LOG) THEN
        FN.REDO.BCR.PROCESS.LOG = "F.REDO.BCR.PROCESS.LOG"
        CALL OPF(FN.REDO.BCR.PROCESS.LOG, F.REDO.BCR.PROCESS.LOG)
    END
RETURN

*------------------------------------------------------------------------------------------------------------------
END
