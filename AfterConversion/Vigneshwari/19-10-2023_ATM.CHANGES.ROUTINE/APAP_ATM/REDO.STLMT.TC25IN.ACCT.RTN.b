* @ValidationCode : Mjo1Mjc5MjQyODc6Q3AxMjUyOjE2OTc2OTkzNDg2MjE6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Oct 2023 12:39:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE REDO.STLMT.TC25IN.ACCT.RTN
**************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.STLMT.TC25IN.ACCT.RTN
*****************************************************************
*Description: This routine is to reverse the account entries raised for
*             the received 05,06,07 due to wrong transaction.
****************************************************************************
*In parameter : None
*Out Parameter : None
************************************************************************
*Modification History:
************************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   2-12-2010       DHAMU S              ODR-2010-08-0469         Initial Creation
*  26-Nov-2018      Vignesh Kumaar M R   CI#2795720               BRD001 - FAST FUNDS SERVICES
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           INCLUDE TO INSERT
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*17/10/2023	VIGNESHWARI       ADDED COMMENT FOR ATM CHANGES         LINES IS ADDED
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    *$INSERT I_F.ATM.REVERSAL  --CAMBIO JORGE
	$INSERT I_F.ATM.TRANSACTION  ;*--CAMBIO JORGE	;* ATM changes by Mario
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON ;*AUTO R22 CODE CONVERSION - END
    GOSUB PROCESS
RETURN
 
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    IF ERROR.MESSAGE EQ 'USAGE.CODE' THEN
*        IF SET.OCT.FLAG NE 1 THEN
        GOSUB REP.GET.ACCOUNT
*        END
        GOSUB ACCT.ENTRY
    END ELSE
*        IF SET.OCT.FLAG NE 1 THEN
        GOSUB GET.DR.CR.ACT
*        END
        GOSUB ACCT.ENTRY
    END
RETURN

*--------------
REP.GET.ACCOUNT:
*---------------
    Y.TC.CODE= TC.CODE:'2'
    LOCATE Y.TC.CODE IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS THEN
        IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS>
        END ELSE
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS>
        END
    END
RETURN

*-------------
GET.DR.CR.ACT:
*-------------
    LOCATE TC.CODE IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS THEN
        IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS>
        END ELSE
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS>
        END
    END
RETURN
*---------------------------------------------------------------
ACCT.ENTRY:
*---------------------------------------------------------------
*IF DR.ACCT EQ '' THEN
*DR.ACCT=R.ATM.REVERSAL<AT.REV.ACCOUNT.NUMBER>
*END
*IF CR.ACCT EQ '' THEN
*CR.ACCT=R.ATM.REVERSAL<AT.REV.ACCOUNT.NUMBER>
*END

* Fix for 2795720 [BRD001 - FAST FUNDS SERVICES]

    IF SET.OCT.FLAG EQ 1 THEN

        FN.REDO.APAP.H.PARAMETER = 'F.REDO.APAP.H.PARAMETER'
        CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,ERR.PARAM)

        CHECK.OCT.ACTYPE = 'PAGAR'
        LOCATE CHECK.OCT.ACTYPE IN R.REDO.APAP.H.PARAMETER<PARAM.OCT.FF.ACCT,1> SETTING OCT.POS THEN
            IF R.REDO.STLMT.LINE<VISA.SETTLE.SRC.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
                DR.ACCT = R.REDO.APAP.H.PARAMETER<PARAM.OCT.DOP.ACCT,OCT.POS>
            END ELSE
                DR.ACCT = R.REDO.APAP.H.PARAMETER<PARAM.OCT.USD.ACCT,OCT.POS>
            END
        END

        *IF R.ATM.REVERSAL NE '' THEN  --CAMBIO JORGE
		IF R.ATM.TRANSACTION NE '' THEN  ;*--CAMBIO JORGE	;* ATM changes by Mario
            CHECK.OCT.ACTYPE = 'COBRAR'
        END ELSE
            CHECK.OCT.ACTYPE = 'REVPAGAR'
        END
        LOCATE CHECK.OCT.ACTYPE IN R.REDO.APAP.H.PARAMETER<PARAM.OCT.FF.ACCT,1> SETTING OCT.POS THEN
            IF R.REDO.STLMT.LINE<VISA.SETTLE.SRC.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
                CR.ACCT = R.REDO.APAP.H.PARAMETER<PARAM.OCT.DOP.ACCT,OCT.POS>
            END ELSE
                CR.ACCT = R.REDO.APAP.H.PARAMETER<PARAM.OCT.USD.ACCT,OCT.POS>
            END
        END

    END

* End of Fix

    CR.AMT = R.REDO.STLMT.LINE<VISA.SETTLE.DEST.AMT>

    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=DR.ACCT
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=CR.ACCT

    CALL F.READ(FN.ACCOUNT,CR.ACCT,R.CR.ACC,F.ACCOUNT,ACCT.ERR)
    CALL F.READ(FN.ACCOUNT,DR.ACCT,R.DR.ACC,F.ACCOUNT,ACCT.ERR)
    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> = R.DR.ACC<AC.CURRENCY>
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> = R.CR.ACC<AC.CURRENCY>

    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.ID>=Y.STL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.APPL>='REDO.VISA.STLMT.05TO37'

    IF TC.CODE EQ 26 OR SET.OCT.FLAG EQ 1 THEN
        R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE> = TODAY
    END ELSE
        R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>=TODAY
    END

*R.FUNDS.TRANSFER<FT.LOCAL.REF,>  *; Needs to be clarified
*R.FUNDS.TRANSFER<FT.LOCAL.REF,>  *; Needs to be clarified

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
