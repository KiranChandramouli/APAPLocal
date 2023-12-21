* @ValidationCode : Mjo4MjAwOTk5Mjg6Q3AxMjUyOjE2OTg3NTA2NzQ2MDU6SVRTUzE6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS

* Version 3 21/07/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>1315</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.TXN.CHECK.FIELDS
*
*-----------------------------------------------------------------------
* Check fields subroutine for TFS.TRANSACTION template
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
*-----------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion         USPLATFORM.BP File is Removed , FM , VM to @FM ,@VM
*
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT  I_T24.FS.COMMON ;*R22 Manual Conversion

    $INSERT I_F.COMPANY
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TELLER.TRANSACTION

    $INSERT  I_F.TFS.PARAMETER ;*R22 Manual Conversion
    $INSERT  I_F.TFS.TRANSACTION ;*R22 Manual Conversion
    $USING EB.Display
*
    GOSUB INITIALISE
*
    BEGIN CASE
        CASE AS
            INTO.FIELD = R.NEW(AF)<1,AV,AS>
        CASE AV
            INTO.FIELD = R.NEW(AF)<1,AV>
        CASE OTHERWISE
            INTO.FIELD = R.NEW(AF)
    END CASE
*
    IF COMI = '' AND INTO.FIELD = '' THEN
        GOSUB DEFAULT.FIELDS
    END

    GOSUB CHECK.FIELDS

    IF COMI THEN
        COMI.ENRI.SAVE = COMI.ENRI
        COMI.ENRI = ''
        GOSUB DEFAULT.OTHER.FIELDS
        COMI.ENRI = COMI.ENRI.SAVE
    END

RETURN
*-----------------------------------------------------------------------
INITIALISE:

    E = ''
    ETEXT = ''
    ALLOWED.INTERFACES = TFS$R.TFS.PAR<TFS.PAR.APPLICATION>

    FT.TXN.CHECKFILE = 'FT.TXN.TYPE.CONDITION' :@FM: FT6.SHORT.DESCR :@FM: 'L'
    TT.TXN.CHECKFILE = 'TELLER.TRANSACTION' :@FM: TT.TR.SHORT.DESC :@FM: 'L'
    FN.TXN = 'F.TRANSACTION' ; F.TXN = ''
    FN.VER = 'F.VERSION' ; F.VER = ''

RETURN
*-----------------------------------------------------------------------
DEFAULT.FIELDS:

RETURN
*-----------------------------------------------------------------------
DEFAULT.OTHER.FIELDS:

RETURN
*-----------------------------------------------------------------------
CHECK.FIELDS:

    DEFAULTED.FIELD = '' ; DEFAULTED.ENRI = ''

    BEGIN CASE
        CASE AF EQ TFS.TXN.INTERFACE.TO
            IF COMI THEN
                IF COMI MATCHES ALLOWED.INTERFACES THEN
                    VALID.T24.MODULES = R.COMPANY(EB.COM.APPLICATIONS)
                    LOCATE COMI IN VALID.T24.MODULES<1,1> SETTING MODULE.OK ELSE
                        E = 'EB.RTN.PRODUCT.NOT.INSTALLED'
                    END
                    IF NOT(E) THEN
                        IF COMI EQ 'DC' THEN
                            N(TFS.TXN.INTERFACE.AS) = '20..C'
                            N(TFS.TXN.DC.TXN.CODE.CR) = '5.1.C'
                            N(TFS.TXN.DC.TXN.CODE.DR) = '5.1.C'
                        END ELSE
                            N(TFS.TXN.INTERFACE.AS) = '20.1.C'
                            N(TFS.TXN.DC.TXN.CODE.CR) = '5..C'
                            N(TFS.TXN.DC.TXN.CODE.DR) = '5..C'
                        END
                        DEFAULTED.FIELD<-1> = TFS.TXN.DC.TXN.CODE.CR ; DEFAULTED.ENRI<-1> = ''
                        DEFAULTED.FIELD<-1> = TFS.TXN.DC.TXN.CODE.DR ; DEFAULTED.ENRI<-1> = ''
                    END
                END ELSE
                    E = 'EB-TFS.ALLOWED.INTERFACES' :@FM: CHANGE(ALLOWED.INTERFACES,@VM,',',0) ;*R22 Manual Conversion
                END
            END

        CASE AF EQ TFS.TXN.INTERFACE.AS
            IF COMI THEN
                IF R.NEW(TFS.TXN.INTERFACE.TO) THEN
                    BEGIN CASE
                        CASE R.NEW(TFS.TXN.INTERFACE.TO) EQ 'FT'
                            YCHECKFILE = FT.TXN.CHECKFILE
                            CALL DBR(YCHECKFILE,COMI,COMI.ENRI)
                        CASE R.NEW(TFS.TXN.INTERFACE.TO) EQ 'TT'
                            YCHECKFILE = TT.TXN.CHECKFILE
                            CALL DBR(YCHECKFILE,COMI,COMI.ENRI)
                    END CASE
                    IF ETEXT THEN
                        E = ETEXT
                    END
                END ELSE
                    E = 'EB-TFS.INTERFACE.TO.INP.MISSING'
                END
            END

        CASE AF EQ TFS.TXN.OFS.VERSION
            IF COMI THEN
                APPL = R.NEW(TFS.TXN.INTERFACE.TO)<1,AV>
                IF APPL THEN
                    BEGIN CASE
                        CASE APPL EQ 'FT'
                            APPL = 'FUNDS.TRANSFER'
                        CASE APPL EQ 'TT'
                            APPL = 'TELLER'
                        CASE APPL EQ 'DC'
                            APPL = 'DATA.CAPTURE'
                        CASE OTHERWISE
                            APPL = ''
                    END CASE
                    IF APPL THEN
                        VER.ID = APPL : COMI
                        CALL F.READ(FN.VER,VER.ID,R.VER,F.VER,ERR.VER)
                        IF R.VER THEN
                            COMI.ENRI = VER.ID
                        END ELSE
                            E = 'EB-TFS.MISS.VERSION' :@FM: VER.ID
                        END
                    END ELSE
                        E = 'EB-TFS.INVALID.APPL'
                    END
                END ELSE
                    E = 'EB-TFS.APPL.INPUT.MISSING'
                END
            END

        CASE AF EQ TFS.TXN.DC.TXN.CODE.CR
            IF NOT(COMI) THEN COMI = TFS$R.TFS.PAR<TFS.PAR.DC.TXN.CODE.CR>
            IF COMI THEN
                CR.DR = 'CREDIT'
                GOSUB VALIDATE.TXN.CODE
                IF NOT(E) THEN DEFAULTED.FIELD<-1> = AF
            END

        CASE AF EQ TFS.TXN.DC.TXN.CODE.DR
            IF NOT(COMI) THEN COMI = TFS$R.TFS.PAR<TFS.PAR.DC.TXN.CODE.DR>
            IF COMI THEN
                CR.DR = 'DEBIT'
                GOSUB VALIDATE.TXN.CODE
            END

    END CASE

*    IF DEFAULTED.FIELD AND MESSAGE EQ '' THEN CALL REFRESH.FIELD(DEFAULTED.FIELD,DEFAULTED.ENRI)
    IF DEFAULTED.FIELD AND MESSAGE EQ '' THEN EB.Display.RefreshField(DEFAULTED.FIELD,DEFAULTED.ENRI)  ;*R22 Manual Conversion
RETURN
*-----------------------------------------------------------------------
VALIDATE.TXN.CODE:

    TXN.ID = COMI
    CALL F.READ(FN.TXN,TXN.ID,R.TXN,F.TXN,ERR.TXN)
    IF R.TXN THEN
        IF R.TXN<AC.TRA.DATA.CAPTURE> EQ 'Y' THEN
            IF R.TXN<AC.TRA.DEBIT.CREDIT.IND> NE CR.DR THEN
                E = 'EB-TFS.TXN.CODE.MUST.BE' :@FM: CR.DR
            END
        END ELSE
            E = 'EB-TFS.TXN.CODE.CANT.BE.USED.IN.DC'
        END
    END

RETURN
*-----------------------------------------------------------------------
END


