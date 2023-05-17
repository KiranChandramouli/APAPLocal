SUBROUTINE REDO.ACCT.DEP.DETAILS.SELECT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.RELATION
    $INSERT I_F.CATEGORY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_REDO.ACCT.DEP.DETAILS.COMMON
    $INSERT I_F.REDO.H.TELLER.TXN.CODES

    GOSUB SELECT.PROCES
*
RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT.PROCES:
*-------------
    CALL EB.CLEAR.FILE(FN.REDO.APAP.BKP.REP55,F.REDO.APAP.BKP.REP55)

    SEL.CMD = " SELECT ": FN.ACCT.ENT.LWORK.DAY
    SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
END
