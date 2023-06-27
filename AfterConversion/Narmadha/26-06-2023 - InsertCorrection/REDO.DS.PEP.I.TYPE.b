* @ValidationCode : MjoxNjEwMjQ4MzQ6VVRGLTg6MTY4Nzc3NTU2MzkwOTpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Jun 2023 16:02:43
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
SUBROUTINE REDO.DS.PEP.I.TYPE(Y.TYPE)
*-----------------------------------------------------------------------------
*MODIFICATION HISTROY:
* PACS00371128
**
* 26-06-2023   Narmadha V    Manual R22 conversion   FM to @FM, VM to @VM,command insert file, Call routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
* $INSERT I_F.T24.FUND.SERVICES ; * Manual R22 conversion
    $USING APAP.REDOEB
    GOSUB INIT
    GOSUB PROCESS
RETURN
*
PROCESS:
*=======
*
    IF Y.PEP.INT EQ "SI" THEN
        Y.LOOOKUP.VAL = Y.PEP.TINT
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
    LOC.REF.FIELD = 'L.PEP.INTERM' :@VM: 'L.TYPE.PEP.INT' :@FM: 'L.PEP.INTERM' :@VM: 'L.TYPE.PEP.INT':@FM: 'L.PEP.INTERM' :@VM: 'L.TYPE.PEP.INT'
    LOC.REF.APP = 'TELLER':@FM:'FUNDS.TRANSFER':@FM:'T24.FUND.SERVICES'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    POS.PEP.INT      = LOC.POS<1,1>
    POS.PEP.TYPE.INT = LOC.POS<1,2>
    POS.FT.INT       = LOC.POS<2,1>
    POS.FT.TYPE.INT  = LOC.POS<2,2>
    POS.TFS.INT      = LOC.POS<3,1>
    POS.TFS.TYPE.INT = LOC.POS<3,2>
*
    Y.TXN.PREF = ID.NEW[1,2]
    IF Y.TXN.PREF EQ "TT" THEN
        Y.PEP.INT   = R.NEW(TT.TE.LOCAL.REF)<1,POS.PEP.INT>
        Y.PEP.TINT  = R.NEW(TT.TE.LOCAL.REF)<1,POS.PEP.TYPE.INT>
    END
*
    IF Y.TXN.PREF EQ "FT" THEN
        Y.PEP.INT   = R.NEW(FT.LOCAL.REF)<1,POS.FT.INT>
        Y.PEP.TINT  = R.NEW(FT.LOCAL.REF)<1,POS.FT.TYPE.INT>
    END
*
    IF Y.TXN.PREF EQ "T2" THEN
        Y.PEP.INT   = R.NEW(TFS.LOCAL.REF)<1,POS.TFS.INT>
        Y.PEP.TINT  = R.NEW(TFS.LOCAL.REF)<1,POS.TFS.TYPE.INT>
    END
    Y.DESC.VAL  = ''
    Y.LOOKUP.ID = "L.TYPE.PEP.INT"
RETURN

END
