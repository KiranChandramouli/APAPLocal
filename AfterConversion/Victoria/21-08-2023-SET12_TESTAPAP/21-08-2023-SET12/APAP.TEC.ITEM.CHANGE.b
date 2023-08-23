* @ValidationCode : MjotMTA2ODgwMjczMjpDcDEyNTI6MTY5MjYwMjk1ODI2Njp2aWN0bzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Aug 2023 12:59:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TESTAPAP
SUBROUTINE APAP.TEC.ITEM.CHANGE
* 02/01/2017 - Sunder - ITSS
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TEC.ITEMS

    FN.TEC.ITEMS = 'F.TEC.ITEMS'
    F.TEC.ITEMS = ''
    CALL OPF(FN.TEC.ITEMS,F.TEC.ITEMS)

    SEL.CMD = 'SELECT ':FN.TEC.ITEMS: ' WITH THRESHOLD.TYPE NE ""'
    Y.LIST = ''
    CALL EB.READLIST(SEL.CMD,Y.LIST,'','',Y.ERR)
    LOOP
        REMOVE Y.TEC.ID FROM Y.LIST SETTING Y.TEC.POS
    WHILE Y.TEC.ID:Y.TEC.POS
        R.TEC.ITEMS = ''
        CALL F.READ(FN.TEC.ITEMS,Y.TEC.ID,R.TEC.ITEMS,F.TEC.ITEMS,Y.TEC.ERR)
        IF R.TEC.ITEMS THEN
            Y.CNT = DCOUNT(R.TEC.ITEMS<TEC.IT.THRESHOLD.TYPE>,@VM) ;*R22 MANUAL CONVERSION
            FOR I = 1 TO Y.CNT
                IF R.TEC.ITEMS<TEC.IT.THRESHOLD.TYPE,I> NE 'IGNORE' THEN
                    R.TEC.ITEMS<TEC.IT.THRESHOLD.TYPE,I> = 'IGNORE'
                END
            NEXT I
            CALL F.LIVE.WRITE(FN.TEC.ITEMS,Y.TEC.ID,R.TEC.ITEMS)
        END
    REPEAT
    CALL JOURNAL.UPDATE("APAP.TEC.ITEM.CHANGE")

RETURN
END
