* @ValidationCode : MjozMDMxOTk5NDU6Q3AxMjUyOjE2OTI4NzE3ODk5MzM6SVRTUzotMTotMTozOTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Aug 2023 15:39:49
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
$PACKAGE APAP.REDOEB
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
