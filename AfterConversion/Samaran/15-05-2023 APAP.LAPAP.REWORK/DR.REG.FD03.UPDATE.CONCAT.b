* @ValidationCode : MjoxMjg1ODA5Mzg1OkNwMTI1MjoxNjgyMzIzMjc2MDUxOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 13:31:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.FD03.UPDATE.CONCAT(REC.ID)
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.FD03.UPDATE.CONCAT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Customer Details for
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 02-Aug-2014  Ashokkumar.V.P      PACS00316981 - Added EB.READ.HISTORY.REC file.
* 01-Sep-2014  Ashokkumar.V.P      PACS00316981 - changed to capture all the foreign currency less than 1000.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  REGREP.BP,LAPAP.BP,T24.BP is removed ,$INCLUDE to$INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_DR.REG.FD03.UPDATE.CONCAT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.DR.REG.FD03.PARAM
    $INSERT I_F.DR.REG.FD03.CONCAT ;*R22 AUTO CODE CONVERSION


    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------
PROCESS:
********
*
    CONCAT.ID = LAST.WRK.DATE
*
    CALL F.READ(FN.ACCT.ENT.LWORK.DAY, REC.ID, R.ACCT.ENT.LWORK.DAY, F.ACCT.ENT.LWORK.DAY, ERR.ACCT.LWORK)
    CTR.STMT.ID = 1
    CNT.STMT.ID = DCOUNT(R.ACCT.ENT.LWORK.DAY,@FM)
    LOOP
    WHILE CTR.STMT.ID LE CNT.STMT.ID
        STMT.ID = R.ACCT.ENT.LWORK.DAY<CTR.STMT.ID>
        R.STMT.ENTRY = ''; STMT.ENTRY.ERR = ''; STMT.TXN.TYPE = ''
        CALL F.READ(FN.STMT.ENTRY,STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        TXN.FT.TT = ''; AMT.LCY = ''; STMT.CCY = ''
        TXN.FT.TT = R.STMT.ENTRY<AC.STE.SYSTEM.ID>
        AMT.LCY = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        AMT.FCY = R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
        STMT.CCY = R.STMT.ENTRY<AC.STE.CURRENCY>

*        IF AMT.LCY LE AMT.CONV.LCY AND TXN.FT.TT EQ 'FT' THEN
        IF AMT.FCY LE YTHRESHOLD.FAMT AND TXN.FT.TT EQ 'FT' AND STMT.CCY NE 'DOP' THEN
            TXN.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>[1,12]
            STMT.TXN.TYPE = TXN.REF
            ERR.FT.HIS = ''; R.TXN = ''
            CALL EB.READ.HISTORY.REC(F.FT.HIS,TXN.REF,R.TXN,ERR.FT.HIS)
            TXN.CODE =  R.TXN<FT.TRANSACTION.TYPE>
            R.FT.TXN.TYPE.CONDITION = ''; FT.TXN.TYPE.CONDITION.ERR = ''
            CALL F.READ(FN.FT.TXN.TYPE.CONDITION,TXN.CODE,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,FT.TXN.TYPE.CONDITION.ERR)
            L.FTTC.PAY.TYPE.VAL = R.FT.TXN.TYPE.CONDITION<FT6.LOCAL.REF,L.FTTC.PAY.TYPE.POS>
            LOCATE L.FTTC.PAY.TYPE.VAL IN FTTC.PAY.TYPES<1> SETTING FTTC.PAY.TYPE.POS THEN
                GOSUB UPDATE.CONCAT.TABLE
            END
        END
        CTR.STMT.ID += 1
    REPEAT
*
RETURN
*-----------------------------------------------------------------------------------
UPDATE.CONCAT.TABLE:
*------------------*
*
    R.DR.REG.FD03.CONCAT = ''; DR.REG.FD03.CONCAT.ERR = ''
    CALL F.READ(FN.DR.REG.FD03.CONCAT,CONCAT.ID,R.DR.REG.FD03.CONCAT,F.DR.REG.FD03.CONCAT,DR.REG.FD03.CONCAT.ERR)
    IF R.DR.REG.FD03.CONCAT THEN
        CNT.STMT = DCOUNT(R.DR.REG.FD03.CONCAT,@FM)
        CTR.STMT = CNT.STMT + 1
*        R.DR.REG.FD03.CONCAT<CTR.STMT> = STMT.ID
        TXN.POS = ''
        LOCATE TXN.REF IN R.DR.REG.FD03.CONCAT<1> SETTING TXN.POS ELSE
            R.DR.REG.FD03.CONCAT<CTR.STMT> = STMT.TXN.TYPE
        END
    END ELSE
*        R.DR.REG.FD03.CONCAT<1> = STMT.ID
        R.DR.REG.FD03.CONCAT<1> = STMT.TXN.TYPE
    END
    CALL F.WRITE(FN.DR.REG.FD03.CONCAT,CONCAT.ID,R.DR.REG.FD03.CONCAT)
*
RETURN
*-----------------------------------------------------------------------------------
END
