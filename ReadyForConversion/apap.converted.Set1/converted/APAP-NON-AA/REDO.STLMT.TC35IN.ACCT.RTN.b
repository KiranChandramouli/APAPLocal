SUBROUTINE REDO.STLMT.TC35IN.ACCT.RTN
**************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.STLMT.TC35IN.ACCT.RTN
*****************************************************************
*Description: This routine is to reverse the account entries raised for
*             the received 05,06,07 due to wrong transaction
****************************************************************************
*In parameter : None
*Out Parameter : None
************************************************************************
*Modification History:
************************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   2-12-2010       DHAMU S              ODR-2010-08-0469         Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CURRENCY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON



    GOSUB PROCESS

RETURN

*--------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------
    IF R.ATM.REVERSAL NE '' THEN
        LOCATE TC.CODE IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS THEN
            IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
                DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS>
                CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS>
            END ELSE
                DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS>
                CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS>
            END

        END
        GOSUB ACCT.ENTRY

    END

RETURN
*---------------------------------------------------------------
ACCT.ENTRY:
*---------------------------------------------------------------

    CR.AMT = R.REDO.STLMT.LINE<VISA.SETTLE.DEST.AMT>

    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.ID>=Y.STL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.APPL>='REDO.VISA.STLMT.05TO37'
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=DR.ACCT
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=CR.ACCT

    CALL F.READ(FN.ACCOUNT,CR.ACCT,R.CR.ACC,F.ACCOUNT,ACCT.ERR)
    CALL F.READ(FN.ACCOUNT,DR.ACCT,R.DR.ACC,F.ACCOUNT,ACCT.ERR)
    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> = R.DR.ACC<AC.CURRENCY>
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> = R.CR.ACC<AC.CURRENCY>



    IF TC.CODE EQ 36 THEN
        R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>=TODAY
    END ELSE
        R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE> = TODAY
    END
    TRANSACTION.ID = ''
    PROCESS = ''
    GTSMODE  =''
    OFSRECORD  = ''
    OFS.MSG.ID = ''
    OFS.ERR = ''
    OFS.STRING = ''
    OFS.ERR = ''
    APP.NAME =  'FUNDS.TRANSFER'
    OFSVERSION = R.REDO.APAP.H.PARAMETER<PARAM.FT.VERSION,POS>
    OFSFUNCT = 'I'
    OFS.SOURCE.ID = 'REDO.VISA.OUTGOING'
    NO.OF.AUTH = '0'
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFS.STRING)
    CALL OFS.POST.MESSAGE(OFS.STRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
END
