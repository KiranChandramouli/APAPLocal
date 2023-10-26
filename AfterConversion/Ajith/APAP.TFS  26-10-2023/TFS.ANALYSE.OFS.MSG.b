* @ValidationCode : MjotMTU1NDY1NzExMTpDcDEyNTI6MTY5ODMwNzE2OTYyMzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Oct 2023 13:29:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion                No Change
*
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>139</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.ANALYSE.OFS.MSG(OFS.MSG,RET.MSG,OFS.OVERRIDES,UL.CO.CODE)
*
* Subroutine to look into OFS OUT Messages and return any Error from
* the OFS Message
*
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE

    IF OFS.OVERRIDES OR UL.CO.CODE THEN
        GOSUB RETRIEVE.OVERRIDES
    END ELSE
        RET.MSG = ''

        BEGIN CASE
            CASE OFS.MSG[1,18] EQ 'SECURITY VIOLATION'
                RET.MSG = 'SECURITY VIOLATION - NOT ENOUGH RIGHTS'

            CASE OFS.MSG[1,15] EQ 'HOLD - OVERRIDE'

            CASE OTHERWISE

                IF INDEX(OFS.MSG,'/',1) THEN
                    POSSIBLE.ERR = FIELD(OFS.MSG,'/',3)[1,2] EQ '-1'
                    IF POSSIBLE.ERR THEN
                        RET.MSG = FIELD(OFS.MSG,'/',4)
                        IF RET.MSG THEN
                            RET.MSG = FIELD(RET.MSG,',',2,1)
                        END ELSE
                            RET.MSG = FIELD(OFS.MSG,',',2,1)
                        END
                    END
                END ELSE
                    RET.MSG = OFS.MSG ; * To capture 'INVALID FIELD NAME' errors
                END
        END CASE
    END

RETURN
*=======================================================================
RETRIEVE.OVERRIDES:

    OFS.OVERRIDES = ''
    NO.OF.OFIELDS = DCOUNT(OFS.MSG,',')
    UL.CHARGE = ''
    FOR OFLD.CNT = 1 TO NO.OF.OFIELDS
        OFS.FLD.VAL = OFS.MSG[',',OFLD.CNT,1]
        OFS.FLD.NAME = OFS.FLD.VAL['=',1,1]
        OFS.FLD.NAME = OFS.FLD.NAME[':',1,1]
        BEGIN CASE
            CASE OFS.FLD.NAME = 'OVERRIDE'
                OFS.OVERRIDES<1,-1> = OFS.FLD.VAL['=',2,1]
            CASE OFS.FLD.NAME = 'CO.CODE'
                UL.CO.CODE = OFS.FLD.VAL['=',2,1]
        END CASE
    NEXT OFLD.CNT

RETURN
*=======================================================================
END
