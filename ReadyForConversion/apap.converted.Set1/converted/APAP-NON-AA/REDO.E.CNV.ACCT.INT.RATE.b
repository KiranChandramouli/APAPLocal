SUBROUTINE REDO.E.CNV.ACCT.INT.RATE
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : HITESH N
* Program Name  : REDO.E.CNV.ACCT.INT.RATE
* ODR NUMBER    : ODR-2010-03-0137
*-------------------------------------------------------------------------
* Description : This conversion routine is used to fetch the Interest rate from GROUP.CREDIT.INT table

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB GET.INT.RATE
RETURN
*****
INIT:
*****
    R.ACCOUNT = ''
    ACC.ERR = ''
    Y.GCI.ID = ''
    Y.INT.RATE = ''
    Y.GDI.ERR = ''
    R.GROUP.CREDIT.INT = ''
    Y.OUT.GCI.ID = ''
    ACT.NO = ''
RETURN
***********
OPEN.FILES:
***********
*
    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)
****
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*****
    ACT.NO = O.DATA
RETURN
*************
GET.INT.RATE:
*************
    CALL F.READ(FN.ACCOUNT,ACT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.GCI.ID = R.ACCOUNT<AC.CONDITION.GROUP>:R.ACCOUNT<AC.CURRENCY>
    CALL RG.GET.LAST.MATCH(FN.GROUP.CREDIT.INT,Y.GCI.ID,Y.OUT.GCI.ID)
*********
    IF Y.OUT.GCI.ID THEN
        CALL CACHE.READ(FN.GROUP.CREDIT.INT, Y.OUT.GCI.ID, R.GROUP.CREDIT.INT, Y.GDI.ERR)
        IF R.GROUP.CREDIT.INT THEN
            Y.INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE,1>
        END
    END
    O.DATA = Y.INT.RATE
*****
RETURN
END
