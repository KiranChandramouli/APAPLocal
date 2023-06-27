* @ValidationCode : MjotNjE5ODgyNzA5OlVURi04OjE2ODc3NzU0MDE4ODk6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Jun 2023 16:00:01
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>

*-----------------------------------------------------------------------------
SUBROUTINE REDO.DS.PEP.B.TYPE(Y.TYPE)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
* PACS00371128
* 26-06-2023   Narmadha V     Manual R22 conversion  FM to @FM, VM to @VM,command insert file, Call routine format modified
**
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
* $INSERT I_F.T24.FUND.SERVICES ; Manual R22 conversion
    $USING APAP.REDOEB

    GOSUB INIT
    GOSUB PROCESS
RETURN
*
PROCESS:
*=======
*
    IF Y.PEP.BEN EQ "SI" THEN
        Y.LOOOKUP.VAL = Y.PEP.TBEN
        GOSUB GET.EBL.DESC
    END
*
    Y.TYPE = Y.DESC.VAL
RETURN
*
GET.EBL.DESC:
*============
*
    Y.DESC.VAL  = ''
    APAP.REDOEB.redoEbLookupList(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2) ;* Manual R22 Conversion
RETURN
*
INIT:
*====
*
    LOC.REF.FIELD = 'L.PEP.BEN' :@VM: 'L.TYPE.PEP.BEN' :@FM: 'L.PEP.BEN' :@VM: 'L.TYPE.PEP.BEN':@FM: 'L.PEP.BEN' :@VM: 'L.TYPE.PEP.BEN'
    LOC.REF.APP = 'TELLER':@FM:'FUNDS.TRANSFER':@FM:'T24.FUND.SERVICES'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    POS.PEP.BEN      = LOC.POS<1,1>
    POS.PEP.TYPE.BEN = LOC.POS<1,2>
    POS.FT.BEN       = LOC.POS<2,1>
    POS.FT.TYPE.BEN  = LOC.POS<2,2>
    POS.TFS.BEN      = LOC.POS<3,1>
    POS.TFS.TYPE.BEN = LOC.POS<3,2>
*
    Y.TXN.PREF = ID.NEW[1,2]
    IF Y.TXN.PREF EQ "TT" THEN
        Y.PEP.BEN   = R.NEW(TT.TE.LOCAL.REF)<1,POS.PEP.BEN>
        Y.PEP.TBEN  = R.NEW(TT.TE.LOCAL.REF)<1,POS.PEP.TYPE.BEN>
    END
*
    IF Y.TXN.PREF EQ "FT" THEN
        Y.PEP.BEN   = R.NEW(FT.LOCAL.REF)<1,POS.FT.BEN>
        Y.PEP.TBEN  = R.NEW(FT.LOCAL.REF)<1,POS.FT.TYPE.BEN>
    END
*
    IF Y.TXN.PREF EQ "T2" THEN
        Y.PEP.BEN= R.NEW(TFS.LOCAL.REF)<1,POS.TFS.BEN>
        Y.PEP.TBEN  = R.NEW(TFS.LOCAL.REF)<1,POS.TFS.TYPE.BEN>
    END
    Y.DESC.VAL  = ''
    Y.LOOKUP.ID = "L.TYPE.PEP.INT"
RETURN

END
