SUBROUTINE STOCK.GENERATION.VALIDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the STOCK.GENERATION table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : STOCK.GENERATION.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*12.03.2010      SUDHARSANAN S      ODR-2009-10-0319 INITIAL CREATION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.GENERATION
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK
    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
******
    FN.CERTIFIED.CHEQUE.STOCK ='F.CERTIFIED.CHEQUE.STOCK'
    F.CERTIFIED.CHEQUE.STOCK = ''
    CALL OPF(FN.CERTIFIED.CHEQUE.STOCK,F.CERTIFIED.CHEQUE.STOCK)
    Y.CHEQUE.STOCK.ID=''
RETURN

PROCESS:
*********
*Get the field Values from stock.generation and update the CERTIFIED.CHEQUE.STOCK table
    Y.TYPE.BENEF = R.NEW(STO.GEN.TYPE.BENEF)
    Y.YEAR = FMT(R.NEW(STO.GEN.YEAR),'R%2')
    Y.START.SEQ.NO = FMT(R.NEW(STO.GEN.START.SEQ.NO),'R%6')
    Y.NO.OF.INST = R.NEW(STO.GEN.NO.OF.INST)
    Y.START.SEQ.NO.OLD = FMT(R.OLD(STO.GEN.START.SEQ.NO),'R%6')
    Y.NO.OF.INST.OLD = R.OLD(STO.GEN.NO.OF.INST)
    IF Y.START.SEQ.NO NE Y.START.SEQ.NO.OLD OR Y.NO.OF.INST NE Y.NO.OF.INST.OLD THEN
        NO.OF.INST=1
        LOOP
        WHILE NO.OF.INST LE Y.NO.OF.INST
            Y.CHEQUE.STOCK.ID<-1>=Y.TYPE.BENEF:Y.YEAR:Y.START.SEQ.NO
            Y.CHEQUE.STK.ID=Y.CHEQUE.STOCK.ID<NO.OF.INST>
            CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID,R.CERT.CHEQ.STK,F.CERTIFIED.CHEQUE.STOCK,CERT.CHEQ.ERR)
            IF R.CERT.CHEQ.STK NE '' THEN
                AF = STO.GEN.START.SEQ.NO
                ETEXT = "TT-INSTRUMENT.ALREADY.RECEIVED":@FM:Y.CHEQUE.STK.ID
                CALL STORE.END.ERROR
            END
            Y.START.SEQ.NO += 1
            NO.OF.INST += 1
        REPEAT
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
END
