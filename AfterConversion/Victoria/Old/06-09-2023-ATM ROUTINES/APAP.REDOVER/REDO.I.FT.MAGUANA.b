* @ValidationCode : MjotMTQ5NzQxMjY3MTpDcDEyNTI6MTY4MjQxMjMyOTMxOTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.I.FT.MAGUANA
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.I.FT.MAGUANA
*Date              : 23.11.2010
*--------------------------------------------------------------------------
*Description :
*-------------
*This routine is to identify whether the transaction is from Maguana And Paravia
*Maguana paravia is the Affiliated POS of APAP in respective banks teller counted
*This routine will be attached to version attached to INTRF.MAPPING record with ids like ISO020015xxxx1
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*---------------
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.DC.MAG.PARAVIA
    $INSERT I_AT.ISO.COMMON


    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.LATAM.DC.MAG.PARAVIA='F.LATAM.DC.MAG.PARAVIA'
    F.LATAM.DC.MAG.PARAVIA=''
    CALL OPF(FN.LATAM.DC.MAG.PARAVIA,F.LATAM.DC.MAG.PARAVIA)
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ID='SYSTEM'

    CALL CACHE.READ(FN.LATAM.DC.MAG.PARAVIA,Y.ID,R.LATAM.DC.MAG.PARAVIA,MAG.ERR)

    IF R.LATAM.DC.MAG.PARAVIA  NE ''  THEN
        ISO.FLD=R.LATAM.DC.MAG.PARAVIA<MAG.PARAVIA.ISO.FIELD.POS>
        POS.TYPE=AT$INCOMING.ISO.REQ(ISO.FLD)


        IF POS.TYPE EQ R.LATAM.DC.MAG.PARAVIA<MAG.PARAVIA.ISO.VALUE> THEN

*FIELD NOT FOUND IN TEMPLATE ;*AUTO R22 CODE CONVERSION

            ISO.FLD.ACPTR=R.LATAM.DC.MAG.PARAVIA<MAG.PARAVIA.ISO.FLD.ACCEPTOR>
            ISO.FLD.ACPTR.VAL=AT$INCOMING.ISO.REQ(ISO.FLD.ACPTR)

            LOCATE ISO.FLD.ACPTR.VAL IN R.LATAM.DC.MAG.PARAVIA<MAG.PARAVIA.MAGUANA.PARAVIA,1> SETTING ACPTR.POS THEN
                COMI=R.LATAM.DC.MAG.PARAVIA<MAG.PARAVIA.FTTC.ID>
            END
        END
    END
RETURN
END
