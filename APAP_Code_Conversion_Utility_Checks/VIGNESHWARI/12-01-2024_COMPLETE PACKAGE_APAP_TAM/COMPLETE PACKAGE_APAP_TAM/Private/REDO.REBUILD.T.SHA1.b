* @ValidationCode : MjotMTMzMjUzMzY5MTpDcDEyNTI6MTcwNDk1OTI2NDc2MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 13:17:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
*AZ.ACCOUNT id read from that application. And fetch the position of the local
*referance AZ.ACCOUNT id is read from AZ.ACCOUNT application and
*it fetches the position of local reference value L.AZ.SHA1.CODE . Using that get the sha1.code
*And make sha1.code as ID and store the corresponding account id in template
*-----------------------------------------------------------------------------
$PACKAGE APAP.TAM
SUBROUTINE REDO.REBUILD.T.SHA1
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
*09.06.2023    Santosh         R22 Manual Conversion     Added package, assigned ACC.ID = ''
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.T.SHA1
    $USING EB.LocalReferences
    GOSUB INIT
    GOSUB OPEN
    GOSUB PROCESS

RETURN


******************
INIT:

    SEL.CMD=''
    AZ.SEL.LIST=''
    AZ.ERR=''
    AZ.ACCOUNT.ID=''
    SEL.POS=0
    R.CUS=''
    ERR.SHA1=''
    POS=0

    AZ.NOR=0
    ID.SHA1=''


    R.CUS.SHA1=''
    ERR.SHA2=''
RETURN
***********
OPEN:

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.T.SHA1 = 'F.REDO.T.SHA1'
    F.REDO.T.SHA1 = ''
    CALL OPF(FN.REDO.T.SHA1,F.REDO.T.SHA1)

    L.AZ.SHA1.CODE.POS = ''
*    CALL GET.LOC.REF('AZ.ACCOUNT','L.AZ.SHA1.CODE',L.AZ.SHA1.CODE.POS)
    EB.LocalReferences.GetLocRef('AZ.ACCOUNT','L.AZ.SHA1.CODE',L.AZ.SHA1.CODE.POS);* R22 UTILITY AUTO CONVERSION
RETURN
**********
PROCESS:

    SEL.CMD="SELECT ":FN.AZ.ACCOUNT

    CALL EB.READLIST(SEL.CMD,AZ.SEL.LIST,'',AZ.NOR,AZ.ERR)

    LOOP

        REMOVE AZ.ACCOUNT.ID FROM AZ.SEL.LIST SETTING SEL.POS

    WHILE AZ.ACCOUNT.ID:SEL.POS

        CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.CUS.SHA1,F.AZ.ACCOUNT,ERR.SHA1)
        IF R.CUS.SHA1 THEN
            SHA1.CODE = R.CUS.SHA1<AZ.LOCAL.REF,L.AZ.SHA1.CODE.POS>
        END
        IF SHA1.CODE THEN
*            CALL F.READ(FN.REDO.T.SHA1,SHA1.CODE,R.SHA1.CODE,F.REDO.T.SHA1,SHA1.ERR)
            CALL F.READU(FN.REDO.T.SHA1,SHA1.CODE,R.SHA1.CODE,F.REDO.T.SHA1,SHA1.ERR,'');* R22 UTILITY AUTO CONVERSION
            IF SHA1.ERR THEN
*R.SHA1.CODE<1> =ACC.ID ; * Tus Start
                ACC.ID = '' ;* R22 Manual Conersion
                R.SHA1.CODE<RE.T.SH.AZ.ACCOUNT.NO> =ACC.ID ; * Tus End
            END
            CALL F.WRITE(FN.REDO.T.SHA1,SHA1.CODE,R.SHA1.CODE)
        END
    REPEAT
RETURN
**************
END
 