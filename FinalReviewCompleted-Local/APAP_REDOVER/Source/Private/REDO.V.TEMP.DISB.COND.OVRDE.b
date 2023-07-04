* @ValidationCode : MjoxMjUwODUxODUxOkNwMTI1MjoxNjgyNDEyMzU0NTg3OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.TEMP.DISB.COND.OVRDE
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: INPUT routine
*------------
*DESCRIPTION:
*------------
* This routine is used to raise the override if loan status and condition having block
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*-----------------------------------------------------------------------------
* Revision History
* Date           Who                        Reference                    Description
* 05-Jun-2017   Edwin Charles D            R15 Upgrade                 Initial Creation
*13-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FT.TT.TRANSACTION


MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    Y.STATUS = R.NEW(FT.TN.L.LOAN.STATUS.1)
    Y.COND = R.NEW(FT.TN.L.LOAN.COND)

    IF Y.STATUS MATCHES 'JudicialCollection' OR Y.STATUS MATCHES 'Write-off' THEN
        AF = FT.TN.L.LOAN.STATUS.1
        CURR.NO = DCOUNT(R.NEW(FT.TN.OVERRIDE),@VM) + 1
        TEXT = 'REDO.LOAN.BLOCK.ST'
        CALL STORE.OVERRIDE(CURR.NO)
    END
    IF Y.COND MATCHES 'Legal' THEN
        AF = FT.TN.L.LOAN.COND
        CURR.NO = DCOUNT(R.NEW(FT.TN.OVERRIDE),@VM) + 1
        TEXT = 'REDO.LOAN.BLOCK.ST'
        CALL STORE.OVERRIDE(CURR.NO)
    END


RETURN


PGM.END:

END
