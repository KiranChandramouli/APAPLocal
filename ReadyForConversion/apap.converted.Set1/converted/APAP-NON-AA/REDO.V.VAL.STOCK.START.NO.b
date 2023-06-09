SUBROUTINE REDO.V.VAL.STOCK.START.NO
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.VAL.STOCK.START.NO
* ODR NO : ODR-2009-12-0275
*----------------------------------------------------------------------
* DESCRIPTION: This routine should check the format of the stock starting number
* in the application STOCK.ENTRY depend upon the value of LOCAL.REF in the application
* CHEQUE.TYPE. This should be included in both STOCK.ENTRY versions STOCK.ENTRY,REDO.FICHA.IMP.PF
* and STOCK.ENTRY, REDO.FICHA.IMP.PJ
* IN PARAMETER: NONE
* OUT PARAMETER: NONE
* LINKED WITH:Versions STOCK.ENTRY,REDO.FICHA.IMP.PF and STOCK.ENTRY, REDO.FICHA.IMP.PJ
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*16.02.2010 S SUDHARSANAN ODR-2009-12-0275 INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.CHEQUE.TYPE
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
******
    FN.STOCK.ENTRY='F.STOCK.ENTRY'
    F.STOCK.ENTRY=''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)
    FN.CHEQUE.TYPE='F.CHEQUE.TYPE'
    F.CHEQUE.TYPE=''
    CALL OPF(FN.CHEQUE.TYPE,F.CHEQUE.TYPE)
    CALL GET.LOC.REF("CHEQUE.TYPE","L.CU.TIPO.CL",TIPO.POS)
RETURN
*********
PROCESS:
*********
    CHEQ.TYPE.ID = R.NEW(STO.ENT.CHEQUE.TYPE)
    R.CHEQ.TYPE=''
    CHQ.ERR=''
    CALL CACHE.READ(FN.CHEQUE.TYPE, CHEQ.TYPE.ID, R.CHEQ.TYPE, CHQ.ERR)
    IF R.CHEQ.TYPE NE '' THEN
        TYPE.OF.CUST = R.CHEQ.TYPE<CHEQUE.TYPE.LOCAL.REF,TIPO.POS>
    END
    IF TYPE.OF.CUST EQ 'PERSONA FISICA' THEN
        STOCK.START.NO = R.NEW(STO.ENT.STOCK.START.NO)
        NEW.STOCK.ST.NO = FMT(STOCK.START.NO,"R%4")
        R.NEW(STO.ENT.STOCK.START.NO) = NEW.STOCK.ST.NO
        IF R.NEW(STO.ENT.STOCK.QUANTITY) GT 9999 THEN
            AF = STO.ENT.STOCK.QUANTITY
            ETEXT = "EB-CHEQ.MAX.LIMIT":@FM:"9999"
            CALL STORE.END.ERROR
        END
    END
    IF TYPE.OF.CUST EQ 'PERSONA JURIDICA' THEN
        STOCK.START.NO = R.NEW(STO.ENT.STOCK.START.NO)
        NEW.STOCK.ST.NO = FMT(STOCK.START.NO,"R%6")
        R.NEW(STO.ENT.STOCK.START.NO) = NEW.STOCK.ST.NO
        IF R.NEW(STO.ENT.STOCK.QUANTITY) GT 999999 THEN
            AF = STO.ENT.STOCK.QUANTITY
            ETEXT = "EB-CHEQ.MAX.LIMIT":@FM:"999999"
            CALL STORE.END.ERROR
        END
    END
RETURN
*------------------------------------------------------------------------------------
END
