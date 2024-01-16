* @ValidationCode : MjotMjA2MTgwOTQ0NjpDcDEyNTI6MTcwNDk2NzIwNzE5MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 15:30:07
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
SUBROUTINE REDO.STORE.DEAL.SLIP.INFO
*----------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.STORE.DEAL.SLIP.INFO
*----------------------------------------------------------------------------------------------------------------------
* Description   : Version Control routine to carry the deal slip information for the reprint
* In parameter  : none
* out parameter : none
*----------------------------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------------------------
* DATE          WHO                  REFERENCE        DESCRIPTION
* 17/06/2013    Vignesh Kumaar R     PACS00290275     REPRINT OPTION FOR THE INAO TT RECORDS
** 17-04-2023 R22 Auto Conversion no changes
** 17-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_RC.COMMON
    $INSERT I_F.REDO.STORE.SPOOL.ID

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------------------------------------------------

    R.REDO.STORE.SPOOL.ID = ''
    FN.REDO.STORE.SPOOL.ID = 'F.REDO.STORE.SPOOL.ID'
    F.REDO.STORE.SPOOL.ID = ''
    CALL OPF(FN.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID)
RETURN

*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------

    IF PGM.VERSION EQ ',REDO.CHQ.NO.TAX' THEN
        CALL PRODUCE.DEAL.SLIP('REDO.TT.EMICHQ')
    END

*    CALL F.READ(FN.REDO.STORE.SPOOL.ID,ID.NEW,R.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID,REDO.STORE.SPOOL.ID.ERR)
    CALL F.READU(FN.REDO.STORE.SPOOL.ID,ID.NEW,R.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID,REDO.STORE.SPOOL.ID.ERR,'');* R22 UTILITY AUTO CONVERSION
    GET.SPOOL.ID = C$LAST.HOLD.ID

    IF GET.SPOOL.ID THEN

        IF NOT(R.REDO.STORE.SPOOL.ID) THEN
            R.REDO.STORE.SPOOL.ID = GET.SPOOL.ID
            CALL F.WRITE(FN.REDO.STORE.SPOOL.ID,ID.NEW,R.REDO.STORE.SPOOL.ID)
        END ELSE
            R.REDO.STORE.SPOOL.ID<RD.SPL.SPOOL.ID,-1> = GET.SPOOL.ID
            CALL F.WRITE(FN.REDO.STORE.SPOOL.ID,ID.NEW,R.REDO.STORE.SPOOL.ID)
        END
    END


RETURN
*----------------------------------------------------------------------------------------------------------------------
* End of Routine
