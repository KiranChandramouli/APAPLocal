$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.GET.PROPTECTION.LIMIT(Y.AA,Y.LIMIT)
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh          R22 Manual Conversion                GLOBUS.BP File Removed, EQ TO = , NE TO #
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Manual Conversion - start
    $INSERT I_EQUATE
    $INSERT I_F.AA.PROTECTION.LIMIT ;*R22 Manual Conversion - end

    Y.ID.AA = Y.AA
 
    AA.PROPERTY.CLASS.ID = "PROTECTION.LIMIT"

    AA.ARRANGEMENT.ID = Y.ID.AA
    YERR = ''
    AA.PROPERTY.ID = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(AA.ARRANGEMENT.ID,AA.PROPERTY.CLASS.ID,'','',AA.PROPERTY.ID,AA.CONDITIONS,YERR)
    IF YERR = '' AND AA.PROPERTY.ID # "" THEN ;*R22 Manual Conversion
        PROTECTION.RULES.ID= AA.PROPERTY.ID
        PROTECTION.RULES= AA.CONDITIONS

        R.PROTECTION.LIMIT = RAISE(PROTECTION.RULES<1>)
        PROTECTION.LIMIT.ID = PROTECTION.RULES.ID<1>
        Y.LIMIT = R.PROTECTION.LIMIT<AA.PRCT.LIMIT.AMOUNT>

    END

RETURN
