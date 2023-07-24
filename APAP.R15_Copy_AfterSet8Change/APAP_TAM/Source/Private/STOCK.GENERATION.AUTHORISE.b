* @ValidationCode : MjoxOTIwMTA4MjA0OkNwMTI1MjoxNjg0ODQyMTU1NjEyOklUU1M6LTE6LTE6NDc1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 475
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE STOCK.GENERATION.AUTHORISE
*------------------------------------------------------------------------------
*DESCRIPTION
* AUTHORISE ROUTINE TO UPDATE CERTIFIED.CHEQUE.STOCK RECORD
*------------------------------------------------------------------------------
*APPLICATION : STOCK.GENERATION
*------------------------------------------------------------------------------
*
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : STOCK.GENERATION.AUTHORISE
*----------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                          ++ to +=1
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.GENERATION
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK
    GOSUB INIT
    GOSUB PROCESS
RETURN
***********
INIT:
***********
    FN.CERTIFIED.CHEQUE.STOCK='F.CERTIFIED.CHEQUE.STOCK'
    F.CERTIFIED.CHEQUE.STOCK=''
    CALL OPF(FN.CERTIFIED.CHEQUE.STOCK,F.CERTIFIED.CHEQUE.STOCK)
    Y.CHEQUE.STOCK.ID=''
RETURN
*--------------------------------------------------------------------------
************
PROCESS:
************
*Upload the certified cheques in the table
    Y.TYPE.BENEF = R.NEW(STO.GEN.TYPE.BENEF)
    Y.YEAR = FMT(R.NEW(STO.GEN.YEAR),'R%2')
    Y.START.SEQ.NO = FMT(R.NEW(STO.GEN.START.SEQ.NO),'R%6')
    Y.NO.OF.INST = R.NEW(STO.GEN.NO.OF.INST)
    Y.RECORD.STATUS=R.NEW(STO.GEN.RECORD.STATUS)
    IF Y.RECORD.STATUS EQ 'INAU' AND V$FUNCTION EQ 'A' THEN
        NO.OF.INST=1
        LOOP
        WHILE NO.OF.INST LE Y.NO.OF.INST
            Y.CHEQUE.STOCK.ID<-1>=Y.TYPE.BENEF:Y.YEAR:Y.START.SEQ.NO
            Y.CHEQUE.STK.ID=Y.CHEQUE.STOCK.ID<NO.OF.INST>
            CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID,R.CERT.CHEQ.STK,F.CERTIFIED.CHEQUE.STOCK,CERT.CHEQ.ERR)
            R.CERT.CHEQ.STK<CERT.STO.STATUS> = 'AVAILABLE'
            CALL F.WRITE(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID,R.CERT.CHEQ.STK)
            Y.START.SEQ.NO += 1
            NO.OF.INST += 1
        REPEAT
    END
    IF Y.RECORD.STATUS EQ 'RNAU' AND V$FUNCTION EQ 'A' THEN
        GOSUB CHEQ.DEL
    END
RETURN
*--------------------------------------------------------------
**********
CHEQ.DEL:
***********
    NO.OF.INST=1
    LOOP
    WHILE NO.OF.INST LE Y.NO.OF.INST
        Y.CHEQUE.STOCK.ID<-1>=Y.TYPE.BENEF:Y.YEAR:Y.START.SEQ.NO
        Y.CHEQUE.STK.ID=Y.CHEQUE.STOCK.ID<NO.OF.INST>
        CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID,R.CERT.CHEQ.STK,F.CERTIFIED.CHEQUE.STOCK,CERT.CHEQ.ERR)
        CALL F.DELETE(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID)
        Y.START.SEQ.NO += 1
        NO.OF.INST += 1
    REPEAT
RETURN
*-------------------------------------------------------------
END
