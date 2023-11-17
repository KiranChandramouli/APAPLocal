* @ValidationCode : MjotNTc1NDgyNTcwOkNwMTI1MjoxNjgwOTQwNzExODM3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Apr 2023 13:28:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.R.COL.EXTRACT.ERROR(MSG, ROUTINE.NAME, Y.TABLE.ID)
********************************************************************
* Company   Name    : APAP
* Developed By      : Temenos Application Management mgudino@temenos.com
*--------------------------------------------------------------------------------------------
* Description:       This program Make the register of ERROR about extract
* Linked With:       REDO.COL.EXTRACT
* In Parameter:      MSG, ROUTINE.NAME, Y.TABLE.ID
* Out Parameter:
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 23/07/2009 - ODR-2009- XX-XXXX
* 14/09/2011 - PACS00110378              Cambio del uso de un regsitro en la aplicacion Locking
*           por almacenarlo en la Cola F.REDO.MSG.COL.QUEUE
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:

    R.REDO.COL.MSG.QUEUE<1> = ROUTINE.NAME
    R.REDO.COL.MSG.QUEUE<2> = "ERROR: ":MSG

*  WRITE R.REDO.COL.MSG.QUEUE TO F.REDO.COL.MSG.QUEUE, Y.MSG.QUEUE.ID ;*Tus Start
    CALL F.WRITE(FN.REDO.COL.MSG.QUEUE,Y.MSG.QUEUE.ID,R.REDO.COL.MSG.QUEUE);*Tus End
    IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
        CALL JOURNAL.UPDATE('')
    END

    CALL OCOMO(MSG)

RETURN
*-----------------------------------------------------------------------------
INITIALISE:

    R.REDO.COL.MSG.QUEUE=""
    FN.REDO.COL.MSG.QUEUE='F.REDO.MSG.COL.QUEUE'
    F.REDO.COL.MSG.QUEUE = ''
    UNIQUE.TIME = ''
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.MSG.QUEUE.ID = Y.TABLE.ID:".":TODAY:".":ID.COMPANY:".":UNIQUE.TIME
    CALL OPF(FN.REDO.COL.MSG.QUEUE,F.REDO.COL.MSG.QUEUE)
RETURN

END
