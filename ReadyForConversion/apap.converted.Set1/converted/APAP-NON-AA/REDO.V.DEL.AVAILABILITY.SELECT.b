SUBROUTINE REDO.V.DEL.AVAILABILITY.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to delete the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.DEL.AVAILABILITY.SELECT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 15.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.REDO.H.BANK.DRAFTS
    $INSERT I_F.REDO.H.DEBIT.CARDS
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.V.DEL.AVAILABILITY.COMMON
*------------------------------------------------------------------------------------------

    GOSUB INIT.SELECT
    GOSUB PROCESS.SELECT
    GOSUB PROGRAM.END
*------------------------------------------------------------------------------------------
INIT.SELECT:
*------------------------------------------------------------------------------------------
    IF CONTROL.LIST EQ '' THEN
        CONTROL.LIST = 'REDO.H.DEPOSIT.RECEIPTS':@FM:'REDO.H.PASSBOOK.INVENTORY':@FM:'REDO.H.ADMIN.CHEQUES':@FM:'REDO.H.BANK.DRAFTS':@FM:'REDO.H.DEBIT.CARDS'
    END

RETURN
*------------------------------------------------------------------------------------------
PROCESS.SELECT:
*------------------------------------------------------------------------------------------
    BEGIN CASE

        CASE CONTROL.LIST<1,1> EQ 'REDO.H.DEPOSIT.RECEIPTS'
            SEL.CMD = 'SELECT ':FN.REDO.H.DEPOSIT.RECEIPTS:' WITH STATUS EQ AVAILABLE'
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,DEP.ERR)
            CALL BATCH.BUILD.LIST('',SEL.LIST)

        CASE CONTROL.LIST<1,1> EQ 'REDO.H.PASSBOOK.INVENTORY'
            SEL.CMD1 = 'SELECT ':FN.REDO.H.PASSBOOK.INVENTORY:' WITH STATUS EQ AVAILABLE'
            CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.RECS,PASS.ERR)
            CALL BATCH.BUILD.LIST('',SEL.LIST1)

        CASE CONTROL.LIST<1,1> EQ 'REDO.H.ADMIN.CHEQUES'
            SEL.CMD2 = 'SELECT ':FN.REDO.H.ADMIN.CHEQUES:' WITH STATUS EQ AVAILABLE'
            CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS,ADM.ERR)
            CALL BATCH.BUILD.LIST('',SEL.LIST2)

        CASE CONTROL.LIST<1,1> EQ 'REDO.H.BANK.DRAFTS'
            SEL.CMD3 = 'SELECT ':FN.REDO.H.BANK.DRAFTS:' WITH STATUS EQ AVAILABLE'
            CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NO.OF.RECS,BNK.ERR)
            CALL BATCH.BUILD.LIST('',SEL.LIST3)

        CASE CONTROL.LIST<1,1> EQ 'REDO.H.DEBIT.CARDS'
            SEL.CMD4 = 'SELECT ':FN.REDO.H.DEBIT.CARDS:' WITH STATUS EQ AVAILABLE'
            CALL EB.READLIST(SEL.CMD4,SEL.LIST4,'',NO.OF.RECS,DEB.ERR)
            CALL BATCH.BUILD.LIST('',SEL.LIST4)

    END CASE

RETURN
*------------------------------------------------------------------------------------------
PROGRAM.END:
*------------------------------------------------------------------------------------------
END
