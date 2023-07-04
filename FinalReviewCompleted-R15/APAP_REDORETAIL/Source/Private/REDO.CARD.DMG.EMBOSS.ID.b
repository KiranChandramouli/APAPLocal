* @ValidationCode : MjoxMDQ3OTUwNDMxOkNwMTI1MjoxNjgxODI4MDAzODAxOklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.CARD.DMG.EMBOSS.ID
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.DMG.EMBOSS


    FN.REDO.CARD.GEN = 'F.REDO.CARD.GENERATION'
    F.REDO.CARD.GEN = ''
    CALL OPF(FN.REDO.CARD.GEN,F.REDO.CARD.GEN)

    IF V$FUNCTION EQ 'I' THEN
        CALL F.READ(FN.REDO.CARD.GEN,ID.NEW,R.REDO.CARD.GEN,F.REDO.CARD.GEN,GEN.ERR)
        IF R.REDO.CARD.GEN THEN
            E='ST-DAMAGE.MARK'
            CALL STORE.END.ERROR
        END

        R.NEW(DMG.LST.REG.ID)=''
        R.NEW(DMG.LST.CARD.TYPE)=''
        R.NEW( DMG.LST.SERIES)=''
        R.NEW( DMG.LST.LOST)=''
        R.NEW( DMG.LST.LOST.DESC )=''
        R.NEW( DMG.LST.DAMAGE)=''
        R.NEW( DMG.LST.DAM.DESC)=''
        R.NEW( DMG.LST.MOVE.FROM.INIT)=''
    END


RETURN

END
