* @ValidationCode : MjotMzU0NDc2OTA1OkNwMTI1MjoxNjgwNzY5MTA5ODYxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 13:48:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.DSPL.OVRDS
*-----------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Shankar Raju
*Program Name      : REDO.INP.DSPL.OVRDS
*Date              : 09/02/2011
*-----------------------------------------------------------------------
*Description       : This is a T24 routine to display the override when WAIVE.CHARGE is set to YES
*Linked With       :
*Linked File       :
*-----------------------------------------------------------------------
* MODIFICATION HISTORY:
* ---------------------
*   DATE            RESOURCE           REFERENCE                 DESCRIPTION
* 09.FEB.2011     SHANKAR RAJU       ODR-2010-03-0447            INITIAL CREATION
* 18.MAR.2011     SHANKAR RAJU       PACS00023913                Including Coditions for Teller
* 11.05.2011      Bharath G          PACS00023918                 Not used in Teller
*06-04-2023      Conversion Tool     R22 Auto Code conversion     VM TO @VM
*06-04-2023      Samaran T           R22 Manual Code Conversion    No Changes
*-----------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : N/A
* Called By : N/A
*-----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System
    $INSERT I_F.OFS.SOURCE

*----------------------------------------------------------------------
* PACS00023918 - S
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    LREF.APPLN = 'FUNDS.TRANSFER'
    LREF.FLDS = 'WAIVE.TAX':@VM:'L.TT.WAI.CHARGE'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
    POS.WAIVE.TAX = LREF.POS<1,1>
    POS.WAIVE.CHARGE = LREF.POS<1,2>

    Y.WAIVE.CHARGE = R.NEW(FT.LOCAL.REF)<1,POS.WAIVE.CHARGE>
    Y.WAIVE.TAX = R.NEW(FT.LOCAL.REF)<1,POS.WAIVE.TAX>

    IF Y.WAIVE.CHARGE EQ "YES" AND (PGM.VERSION NE ',CHQ.GOVT.WITH.TAX' AND PGM.VERSION NE ',CHQ.OTHERS.DEPOSIT') THEN
        CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
        TEXT = 'REDO.WAIVE.CHARGE'
        CALL STORE.OVERRIDE(CURR.NO)
    END
* PACS00072695 -> Added logic for version FUNDS.TRANSFER,CHQ.OTHERS.DEPOSIT

    IF Y.WAIVE.TAX EQ "YES" AND (PGM.VERSION EQ ',CHQ.OTHERS' OR PGM.VERSION EQ ',CHQ.OTHERS.DEPOSIT') THEN
        CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
        TEXT = 'REDO.WAIVE.TAX'
        CALL STORE.OVERRIDE(CURR.NO)
    END

RETURN
*----------------------------------------------------------------------
* PACS00023918 - E
*----------------------------------------------------------------------
*  TAM.V.OVERRIDES = OFS$OVERRIDES
*  TAM.V.OVERRIDES = FIELD(TAM.V.OVERRIDES,FM,2)
*  TAM.V.OVERRIDES = CHANGE(TAM.V.OVERRIDES,'NO','')
*  TAM.V.OVERRIDES = CHANGE(TAM.V.OVERRIDES,VM,'')
*
* To restrict Input routine from triggering while accepting Overrides
* PACS00023918 - S
* IF  NOT(OFS.VAL.ONLY) THEN
* IF TAM.V.OVERRIDES EQ '' THEN
*
* GOSUB INITIALISE
* GOSUB PROCESS
*
* END
* END
* PACS00023918 - E
*
* RETURN
*-----------------------------------------------------------------------
*INITIALISE:
*----------
*IF APPLICATION EQ "TELLER" THEN
*>>>>>>PACS00023913 - Start
*   LREF.APPLN = 'TELLER'
*   LREF.FLDS = 'WAIVE.TAX':VM:'L.TT.WAI.CHARGE'
*   LREF.POS = ''
*
*   CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
*   POS.WAIVE.TAX = LREF.POS<1,1>
*   POS.WAIVE.CHARGE = LREF.POS<1,2>
*
*   Y.WAIVE.CHARGE = R.NEW(TT.TE.LOCAL.REF)<1,POS.WAIVE.CHARGE>
*   Y.WAIVE.TAX = R.NEW(TT.TE.LOCAL.REF)<1,POS.WAIVE.TAX>
*
*   CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
*>>>>>>PACS00023913 - End
*   END ELSE
*
*   LREF.APPLN = 'FUNDS.TRANSFER'
*   LREF.FLDS = 'WAIVE.TAX':VM:'L.TT.WAI.CHARGE'
*   LREF.POS = ''
*
*   CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
*   POS.WAIVE.TAX = LREF.POS<1,1>
*   POS.WAIVE.CHARGE = LREF.POS<1,2>
*
*   Y.WAIVE.CHARGE = R.NEW(FT.LOCAL.REF)<1,POS.WAIVE.CHARGE>
*   Y.WAIVE.TAX = R.NEW(FT.LOCAL.REF)<1,POS.WAIVE.TAX>
*
*   CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),VM) + 1
*  END
*
*  RETURN
*-----------------------------------------------------------------------
*PROCESS:
*-------
*
* IF Y.WAIVE.CHARGE EQ "YES" THEN
* IF C$SPARE(221) NE 'REDO.WAIVE.CHARGE' THEN
* TEXT = 'REDO.WAIVE.CHARGE'
* CALL STORE.OVERRIDE(CURR.NO)
* C$SPARE(221) = 'REDO.WAIVE.CHARGE'
* END
* END
*
* IF Y.WAIVE.TAX EQ "YES" THEN
* IF C$SPARE(222) NE 'REDO.WAIVE.TAX' THEN
* TEXT = 'REDO.WAIVE.TAX'
* CALL STORE.OVERRIDE(CURR.NO)
* C$SPARE(222) = 'REDO.WAIVE.TAX'
* END
* END
*
* RETURN
*-----------------------------------------------------------------------
END
