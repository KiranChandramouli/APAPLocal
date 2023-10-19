* @ValidationCode : MjoxMDgxMDgwNDA5OkNwMTI1MjoxNjkxNjQyOTM1MTkwOnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Aug 2023 10:18:55
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
$PACKAGE APAP.REDOBATCH
*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.MOVE.UNUSED(Y.CARD.LOCK.ID)
*   SUBROUTINE REDO.B.MOVE.UNUSED
***************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.MOVE.UNUSED
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is COB routine to move all unused cards to REDO.CARD.NUMBERS table
*In Parameter      :
*Out Parameter     :
*Files  Used       :
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  30/07/2010       REKHA S            ODR-2010-03-0400 B166      Initial Creation
*10-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED,VM TO @VM, FM TO @FM
*********************************************************************************************************
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_REDO.B.MOVE.UNUSED.COMMON
    $INSERT I_F.REDO.CARD.NUMBERS ;*R22 MANUAL CONVERSION END

*  Y.CARD.LOCK.ID = 'TDVV.DO0010001'
*  CALL REDO.B.MOVE.UNUSED.LOAD

    GOSUB PROCESS
RETURN

********
PROCESS:
********
*To check unused cards in REDO.CARD.NO.LOCK
    CALL F.READ(FN.REDO.CARD.NO.LOCK,Y.CARD.LOCK.ID,R.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK,Y.LOCK.ERR)
    Y.CNT.CARDS = DCOUNT(R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER>,@VM) ;*R22 MANUAL CONVERSION
    Y.CARDS = R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER>
    IF Y.CNT.CARDS GT '1' THEN
        CHANGE @VM TO @FM IN Y.CARDS ;*R22 MANUAL CONVERSION
        Y.INIT = 2
        GOSUB SUB.PROCESS
        R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER> = Y.CARDS
        CALL F.WRITE(FN.REDO.CARD.NO.LOCK,Y.CARD.LOCK.ID,R.REDO.CARD.NO.LOCK)
    END

RETURN

************
SUB.PROCESS:
************
*Move all unused cards to REDO.CARD.NUMBERS table
    CALL F.READ(FN.REDO.CARD.NUMBERS,Y.CARD.LOCK.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,Y.CARD.ERR)
    LOOP
    WHILE Y.INIT LE Y.CNT.CARDS

        Y.CARD.ID = Y.CARDS<2>
        DEL Y.CARDS<2>
        Y.CARD.NOS = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>

*--TODO
* IF Y.CARD.ID EQ '4468800000046755' THEN
*    DEBUG
* END ELSE
*    CONTINUE
* END

        LOCATE Y.CARD.ID IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING Y.CARD.POS THEN
            IF R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,Y.CARD.POS> EQ 'INUSE' THEN
                CONTINUE
            END
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,Y.CARD.POS> = 'AVAILABLE'
        END
        Y.INIT++
    REPEAT
    CALL F.WRITE(FN.REDO.CARD.NUMBERS,Y.CARD.LOCK.ID,R.REDO.CARD.NUMBERS)
RETURN
END
