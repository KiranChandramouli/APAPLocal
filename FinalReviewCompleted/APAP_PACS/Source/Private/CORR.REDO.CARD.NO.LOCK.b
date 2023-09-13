* @ValidationCode : MjoxNTkxMzEwNDMyOkNwMTI1MjoxNjkzMTkzMzAyMTY5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Aug 2023 08:58:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.PACS
*-----------------------------------------------------------------------------
* <Rating>790</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*24-08-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE CORR.REDO.CARD.NO.LOCK
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_F.REDO.CARD.NUMBERS
    COMO.NAME = 'CORR.REDO.CARD.NO.LOCK.':TIME()
    EXECUTE "COMO ON ":COMO.NAME
    OPEN 'F.REDO.CARD.NO.LOCK' TO F.RCNL ELSE NULL
    OPEN 'F.REDO.CARD.NUMBERS' TO F.RCN ELSE NULL
    OPEN 'F.LATAM.CARD.ORDER' TO F.LCO ELSE NULL
    OPEN '&SAVEDLISTS&' TO F.SL ELSE NULL
    LOOP.NOMORE = ''
    READ CORRECTION.IDS FROM F.SL,'REDO.CARD.NUMBERS.ID' THEN

    END
    IF CORRECTION.IDS THEN
        SEL.CMD = 'GET.LIST REDO.CARD.NUMBERS.ID'
    END ELSE
        SEL.CMD = 'SELECT F.REDO.CARD.NUMBERS'
    END
    PRINT "Executing ":SEL.CMD
    EXECUTE SEL.CMD
    LOOP
        READNEXT RCN.ID THEN
            PRINT "Checking ":RCN.ID
            CARD.TYPE = FIELD(RCN.ID,'.',1)
            READ R.RCN FROM F.RCN,RCN.ID THEN
                LOOP
                UNTIL LOOP.NOMORE
                    LOCATE 'AVAILABLE' IN R.RCN<REDO.CARD.NUM.STATUS,1> SETTING Y.AVAILABLE.CARD.POS THEN
                        Y.NXT.AVAILABLE.CARD = R.RCN<REDO.CARD.NUM.CARD.NUMBER,Y.AVAILABLE.CARD.POS>
                        GOSUB READ.LCO
                    END
                    ELSE
                        Y.NXT.AVAILABLE.CARD=''
                    END
                REPEAT
                PRINT "Next Available Card is ":Y.NXT.AVAILABLE.CARD
                READU R.RCNL FROM F.RCNL,RCN.ID THEN

                END
                IF Y.NXT.AVAILABLE.CARD THEN
                    LOCATE Y.NXT.AVAILABLE.CARD IN R.RCNL<REDO.CARD.LOCK.CARD.NUMBER> SETTING POS THEN
                        RELEASE F.RCNL,RCN.ID
                        PRINT "Next Available card ":Y.NXT.AVAILABLE.CARD:" already available in REDO.CARD.NO.LOCK ":RCN.ID:", skipping write"
                    END ELSE
                        Y.CARD.LOCK.LIST = R.RCNL<REDO.CARD.LOCK.CARD.NUMBER>
                        PRINT "Inserting ":Y.NXT.AVAILABLE.CARD:" into REDO.CARD.NO.LOCK ":RCN.ID
                        Y.NEW.CARD.LOCK.LIST = INSERT(Y.CARD.LOCK.LIST,1,1;Y.NXT.AVAILABLE.CARD)
                        R.RCNL<REDO.CARD.LOCK.CARD.NUMBER> = Y.NEW.CARD.LOCK.LIST
                        WRITE R.RCNL TO F.RCNL,RCN.ID
                        PRINT "Writing REDO.CARD.NO.LOCK record ":RCN.ID
                    END
                END ELSE
                    RELEASE F.RCNL,RCN.ID
                    PRINT "No new card available in REDO.CARD.NUMBERS ":RCN.ID
                END
            END
        END ELSE
            EXIT
        END
    REPEAT

RETURN

READ.LCO:
    LCO.ID = CARD.TYPE:'.':Y.NXT.AVAILABLE.CARD
    READU R.LCO FROM F.LCO,LCO.ID THEN
        R.RCN<REDO.CARD.NUM.STATUS,Y.AVAILABLE.CARD.POS> = 'INUSE'
        WRITE R.LCO TO F.LCO,LCO.ID
        PRINT "Card ":LCO.ID:" in incorrect status. Changing to INUSE"
    END ELSE
        RELEASE F.LCO,LCO.ID
        LOOP.NOMORE = 1
    END
RETURN
END
