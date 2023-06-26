* @ValidationCode : MjoxMzczMzMwMTEwOlVURi04OjE2ODc3NjI4MDUzODM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Jun 2023 12:30:05
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
$PACKAGE APAP.REDOENQ
*-----------------------------------------------------------------------------
* <Rating>-82</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.E.FT.TT.NAU(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.FT.TT.NAU
*-----------------------------------------------------------------------------
* Description :Bulit routine to assign value to set variable
* Linked with :
* In Parameter :
* Out Parameter :
*-----------------------------------------------------------------------------
* DATE         DEVELOPER            ODR                      VERSION
* 10-11-2011   Pradeep M            ODR2011080055           INITIAL VERSION
* 27-06-2013   Vignesh Kumaar M R   PACS00296955            INCLUDE TFS RECORDS IN THE LIST
* 10-07-2013   Vignesh Kumaar M R   PACS00306457            DISCARD THE TT THAT ARE CREATED FOR TFS
* 10-03-2014   Vignesh Kumaar M R   PACS00349444            CAN BE AMENDED ONLY USING L.ACTUAL.VERSIO
* 26-06-2023   Narmadha V           Manual R22 Conversion    command insert file, FM to @FM
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
* $INSERT I_F.T24.FUND.SERVICES ;* Manual R22 Conversion
    $INSERT I_F.REDO.AUT.INP.VERSION.NAME ;*

    GOSUB OPEN.PROCESS
    GOSUB PROCESS

RETURN

OPEN.PROCESS:
*-----------

    FN.TELLER$NAU='F.TELLER$NAU'
    F.TELLER$NAU=''
    CALL OPF(FN.TELLER$NAU,F.TELLER$NAU)

    FN.FUNDS.TRANSFER$NAU='F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER$NAU=''
    CALL OPF(FN.FUNDS.TRANSFER$NAU,F.FUNDS.TRANSFER$NAU)

* Fix for PACS00296955 [INCLUDE TFS RECORDS IN THE LIST #1]

    FN.T24.FUND.SERVICES$NAU = 'F.T24.FUND.SERVICES$NAU'
    F.T24.FUND.SERVICES$NAU = ''
    CALL OPF(FN.T24.FUND.SERVICES$NAU,F.T24.FUND.SERVICES$NAU)

* End of Fix

* Fix for PACS00349444 [CAN BE AMENDED ONLY USING L.ACTUAL.VERSIO #1]

    Y.APPLICATION = 'FUNDS.TRANSFER':@FM:'TELLER':@FM:'T24.FUND.SERVICES'
    Y.FIELDS = 'L.ACTUAL.VERSIO':@FM:'L.ACTUAL.VERSIO':@FM:'L.T24FS.TRA.DAY'
    Y.POS = ''

    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.POS)
    Y.FT.POS = Y.POS<1,1>
    Y.TT.POS = Y.POS<2,1>
    Y.TFS.POS = Y.POS<3,1>

    FN.REDO.AUT.INP.VERSION.NAME = 'F.REDO.AUT.INP.VERSION.NAME'
    F.REDO.AUT.INP.VERSION.NAME = ''
    CALL OPF(FN.REDO.AUT.INP.VERSION.NAME,F.REDO.AUT.INP.VERSION.NAME)

*    CALL F.READ(FN.REDO.AUT.INP.VERSION.NAME,'SYSTEM',R.REDO.AUT.INP.VERSION.NAME,F.REDO.AUT.INP.VERSION.NAME,RAIVN.ERR)
    CALL CACHE.READ(FN.REDO.AUT.INP.VERSION.NAME,'SYSTEM',R.REDO.AUT.INP.VERSION.NAME,RAIVN.ERR)
    Y.VERSION.LIST = R.REDO.AUT.INP.VERSION.NAME<REDO.PRE.INP.VER.NAME>
* End of Fix
RETURN

PROCESS:
*-------

    Y.USER.ID=OPERATOR

    GOSUB GET.FT.LIST
    GOSUB GET.TT.LIST
    GOSUB GET.TFS.LIST

    ENQ.DATA = Y.DATA

RETURN

GET.FT.LIST:
*----------*

    SEL.LIST.FT = ''
    NO.OF.REC = ''
    ERR.FT = ''

*    SEL.CMD.FT = "SELECT ":FN.FUNDS.TRANSFER$NAU: " WITH RECORD.STATUS LIKE INA" :"...": " AND INPUTTER LIKE ...":Y.USER.ID:"... BY DATE.TIME"
    SEL.CMD.FT = "SELECT ":FN.FUNDS.TRANSFER$NAU: " WITH RECORD.STATUS LIKE INA" :"...": " AND L.INP.USER.ID EQ ":Y.USER.ID:" BY DATE.TIME"
    CALL EB.READLIST(SEL.CMD.FT,SEL.LIST.FT,'',NO.OF.REC,ERR.FT)

* Fix for PACS00349444 [CAN BE AMENDED ONLY USING L.ACTUAL.VERSIO #2]

    LOOP
        REMOVE FT.ID FROM SEL.LIST.FT SETTING FT.POS
    WHILE FT.ID:FT.POS
        CALL F.READ(FN.FUNDS.TRANSFER$NAU,FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER$NAU,FUNDS.TRANSFER.ERR)
        Y.ACTUAL.VERSION = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.FT.POS>
        GOSUB READ.AND.STORE.VERSION.INFO
        Y.DATA<-1> = FT.ID:'*':Y.ACTUAL.VERSION
    REPEAT

* End of Fix

RETURN


GET.TT.LIST:
*----------*

    SEL.LIST.TT = ''
    NO.OF.REC = ''
    ERR.TT = ''

* Fix for PACS00306457 [DISCARD THE TT THAT ARE CREATED FOR TFS]

*    SEL.CMD.TT = "SELECT ":FN.TELLER$NAU: " WITH RECORD.STATUS LIKE INA" :"...": " AND INPUTTER LIKE ...":Y.USER.ID:"... AND T24.FS.REF UNLIKE T24FS... BY DATE.TIME"
    SEL.CMD.TT = "SELECT ":FN.TELLER$NAU: " WITH RECORD.STATUS LIKE INA" :"...": " AND L.INP.USER.ID EQ ":Y.USER.ID:" AND T24.FS.REF UNLIKE T24FS... BY DATE.TIME"
* End of Fix

    CALL EB.READLIST(SEL.CMD.TT,SEL.LIST.TT,'',NO.OF.REC,ERR.TT)

* Fix for PACS00349444 [CAN BE AMENDED ONLY USING L.ACTUAL.VERSIO #3]

    LOOP
        REMOVE TT.ID FROM SEL.LIST.TT SETTING TT.POS
    WHILE TT.ID:TT.POS
        CALL F.READ(FN.TELLER$NAU,TT.ID,R.TELLER,F.TELLER$NAU,TELLER.ERR)
        Y.ACTUAL.VERSION = R.TELLER<TT.TE.LOCAL.REF,Y.TT.POS>
        GOSUB READ.AND.STORE.VERSION.INFO
        Y.DATA<-1> = TT.ID:'*':Y.ACTUAL.VERSION
    REPEAT

* End of Fix

RETURN

GET.TFS.LIST:
*-----------*

* Fix for PACS00296955 [INCLUDE TFS RECORDS IN THE LIST #2]

    SEL.LIST.TFS = ''
    NO.OF.REC = ''
    ERR.TFS = '' ;

*    SEL.CMD.TFS = "SELECT ":FN.T24.FUND.SERVICES$NAU: " WITH RECORD.STATUS LIKE INA" :"...": " AND INPUTTER LIKE ...":Y.USER.ID:"... BY DATE.TIME"
    SEL.CMD.TFS = "SELECT ":FN.T24.FUND.SERVICES$NAU: " WITH RECORD.STATUS LIKE INA" :"...": " AND L.INP.USER.ID EQ ":Y.USER.ID:" BY DATE.TIME"
    CALL EB.READLIST(SEL.CMD.TFS,SEL.LIST.TFS,'',NO.OF.REC,ERR.TFS)

* Fix for PACS00349444 [CAN BE AMENDED ONLY USING L.ACTUAL.VERSIO #4]

    LOOP
        REMOVE TFS.ID FROM SEL.LIST.TFS SETTING TFS.POS
    WHILE TFS.ID:TFS.POS
        CALL F.READ(FN.T24.FUND.SERVICES$NAU,TFS.ID,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES$NAU,TFS.ERR)
* Y.ACTUAL.VERSION = R.T24.FUND.SERVICES<TFS.LOCAL.REF,Y.TFS.POS> ; Manual R22 Conversion
        Y.DATA<-1> = TFS.ID:'*':Y.ACTUAL.VERSION
    REPEAT

* End of Fix

RETURN

READ.AND.STORE.VERSION.INFO:
*--------------------------*

    LOCATE Y.ACTUAL.VERSION IN Y.VERSION.LIST<1,1> SETTING Y.VER.POS THEN
        Y.DEL.VERSION = R.REDO.AUT.INP.VERSION.NAME<REDO.PRE.DEL.VER.NAME,Y.VER.POS>

        IF Y.DEL.VERSION NE '' THEN
            Y.ACTUAL.VERSION = Y.DEL.VERSION
        END
    END

RETURN

END
