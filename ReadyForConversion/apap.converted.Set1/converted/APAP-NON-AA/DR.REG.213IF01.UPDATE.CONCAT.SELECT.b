SUBROUTINE DR.REG.213IF01.UPDATE.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.UPDATE.CONCAT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 10000 USD made by individual customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 21-Mar-2015   Ashokkumar.V.P        PACS00309079:- Added AA overpayment details.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES

    $INSERT I_DR.REG.213IF01.UPDATE.CONCAT.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.AA.OVERPAYMENT

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
    CONTROL.LIST<-1> = "ACCT.ENT.LWORK.DAY"
    CONTROL.LIST<-1> = "REDO.TRANSACTION"
    CONTROL.LIST<-1> = "REDO.AA.OVERPAY"
RETURN

SEL.PROCESS:
************
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ 'ACCT.ENT.LWORK.DAY'
            LIST.PARAMETER = ''
            LIST.PARAMETER<2> = "F.ACCT.ENT.LWORK.DAY"
            LIST.PARAMETER<7> = "FILTER"
            CALL BATCH.BUILD.LIST(LIST.PARAMETER,"")

        CASE CONTROL.LIST<1,1> EQ 'REDO.TRANSACTION'
            SEL.CMD = ''; SEL.IDS = ''; SEL.LIST = ''; SEL.STS = ''
            SEL.CMD = "SELECT ":FN.REDO.TRANSACTION.CHAIN:" WITH TRANS.DATE EQ ":LAST.WRK.DATE:" AND TRANS.STATUS EQ ''"
            CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SEL.LIST,SEL.STS)
            CALL BATCH.BUILD.LIST('',SEL.IDS)

        CASE CONTROL.LIST<1,1> EQ 'REDO.AA.OVERPAY'
            SEL.CMD = ''; SEL.IDS = ''; SEL.LIST = ''; SEL.STS = ''
            SEL.CMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH PAYMENT.DATE EQ ":LAST.WRK.DATE
            CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SEL.LIST,SEL.STS)
            CALL BATCH.BUILD.LIST('',SEL.IDS)
    END CASE

RETURN
END
