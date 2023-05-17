SUBROUTINE REDO.RPT.ACCT.ALT.LOANS(ACCT.GRP,Y.PREV.ACCOUNT)
*
* Description: The routine to display the loan status and closed status
*
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
* PACS00460181          Ashokkumar.V.P                  09/06/2015           Initial release to show Loan status and closed status
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    YAA.PROD.GRP = ''; YAA.PROD = ''
    R.ACCOUNT = FIELD(ACCT.GRP,'###',1)
    R.AA.ARRANGEMENT = FIELD(ACCT.GRP,'###',2)
    YAA.PROD.GRP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    YAA.PROD = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
RETURN

PROCESS:
********
    Y.PREV.ACCOUNT = ''
    Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END
    IF Y.PREV.ACCOUNT THEN
        GOSUB GET.ALT.ID.FORMAT
    END
RETURN

GET.ALT.ID.FORMAT:
******************
    DEFLT.VAL = ''; FDEFLT.VAL = ''
    BEGIN CASE
        CASE YAA.PROD.GRP EQ 'CONSUMO'
            DEFLT.VAL = '461'
            FDEFLT.VAL = '-461-'
        CASE YAA.PROD.GRP EQ 'COMERCIAL'
            DEFLT.VAL = '460'
            FDEFLT.VAL = '-460-'
        CASE YAA.PROD.GRP EQ 'HIPOTECARIO'
            DEFLT.VAL = '462'
            FDEFLT.VAL = '-462-'
        CASE YAA.PROD.GRP EQ 'LINEAS.DE.CREDITO'
            PFM = '';PVM = ''; PSM = ''
            FINDSTR 'COM' IN YAA.PROD SETTING PFM,PVM,PSM THEN
                DEFLT.VAL = '460'
                FDEFLT.VAL = '-460-'
            END
            PFM = '';PVM = ''; PSM = ''
            FINDSTR 'CONS' IN YAA.PROD SETTING PFM,PVM,PSM THEN
                DEFLT.VAL = '461'
                FDEFLT.VAL = '-461-'
            END
    END CASE
    Y.PREV.ACCOUNT = EREPLACE(Y.PREV.ACCOUNT,DEFLT.VAL,FDEFLT.VAL,1)
RETURN

END
